
#include <stdio.h>
#include <inttypes.h>

#include <FreeRTOS.h>
#include <lwip/init.h>
#include <lwip/sockets.h>
#include <lwip/tcpip.h>
#include <lwip/mem.h>

#include <lwip/sys.h>

#include "pscopts.h"
#include "pscserver.h"
#include "pscmsg.h"
#include "local.h"

#if PSC_MAX_CLIENTS > 32
#  error PSC_MAX_CLIENTS too large
#endif

struct psc_client {
    unsigned index; // ... in psc_key::clients

    int sock; // set to -1 on send error
    struct sockaddr_in peeraddr;

    psc_key *PSC;

    char rxbuf[8+PSC_MAX_RX_MSG_LEN];
};

struct psc_key {
    sys_mutex_t sendguard;
    const psc_config *conf;

    int listen_sock;

    uint32_t clients_used;
    struct psc_client clients[PSC_MAX_CLIENTS];
};

static void handle_client(void *raw);

#define ERROR(BAD, fmt, ...) \
    do{if(BAD) { \
    printf("Error: %s:%d %s" #BAD ": " fmt "\n", __FILE__, __LINE__, __FUNCTION__, ##__VA_ARGS__); return; \
    }}while(0)

#define PERROR(BAD, fmt, ...) \
    do{if(BAD) { \
    printf("Error: %s:%d %s (errno=%d): " fmt "\n", __FILE__, __LINE__, __FUNCTION__, errno, ##__VA_ARGS__); return; \
    }}while(0)

static
struct psc_client* psc_client_alloc(struct psc_key *key)
{
    psc_client* ret = NULL;
    sys_mutex_lock(&key->sendguard);

    for(unsigned i=0; i<PSC_MAX_CLIENTS; i++) {
        if(key->clients_used & (1u<<i))
            continue;

        key->clients_used |= (1u<<i);

        ret = &key->clients[i];
        memset(ret, 0, sizeof(*ret));
        ret->index = i;
        ret->PSC = key;
        break;
    }

    sys_mutex_unlock(&key->sendguard);
    return ret;
}

static
void psc_client_free(struct psc_client* cli)
{
    struct psc_key *key = cli->PSC;
    sys_mutex_lock(&key->sendguard);

    key->clients_used &= ~(1u<<cli->index);
    // spoil
    memset(cli, 0, sizeof(*cli));
    cli->PSC = NULL;

    sys_mutex_unlock(&key->sendguard);
}

void psc_run(psc_key **key, const psc_config *config)
{
    struct sockaddr_in laddr;
    psc_key *PSC;

    memset(&laddr, 0, sizeof(laddr));

    laddr.sin_family = AF_INET;
    laddr.sin_addr.s_addr = htonl(INADDR_ANY);
    laddr.sin_port = htons(config->port);

    ERROR(key && *key, "key already set");

    PSC = mem_calloc(1, sizeof(*PSC));
    ERROR(!PSC, "Unable to allocate %zu bytes for PSC", sizeof(*PSC));
    PSC->conf = config;

    PERROR(sys_mutex_new(&PSC->sendguard)!=ERR_OK, "sendguard");

    PSC->listen_sock = socket(AF_INET, SOCK_STREAM, 0);
    PERROR(PSC->listen_sock==-1, "socket()");

    PERROR(bind(PSC->listen_sock, (void*)&laddr, sizeof(laddr))==-1,
          "bind to port %d", config->port);

    PERROR(listen(PSC->listen_sock, 2)==-1, "listen");

    if(key)
        *key = PSC;

    if(config->start)
        (*config->start)(config->pvt, PSC);

    printf("Server ready on port %d\n", config->port);
    while(1) {
        psc_client *C = NULL;
        struct sockaddr_in caddr;
        socklen_t clen = sizeof(caddr);

        int client = accept(PSC->listen_sock, (void*)&caddr, &clen);
        {
            int val = 1; /* ms */
            if(setsockopt(client, IPPROTO_TCP, TCP_NODELAY, &val, sizeof(val))==-1)
                printf("Can't set TCP_NODELAY\n");
        }
#if LWIP_SO_SNDTIMEO && LWIP_SO_RCVTIMEO
        {
            // time with TCP TX window full before assuming peer is dead.
#  if LWIP_SO_SNDRCVTIMEO_NONSTANDARD
            int val = 1000; /* ms */
#  else
            struct timeval val = {5, 0};
#  endif
            if(setsockopt(client, SOL_SOCKET, SO_SNDTIMEO, &val, sizeof(val))==-1)
                printf("Can't set TX timeout\n");
        }
        {
            // time with no bytes received before assuming peer is gone
#  if LWIP_SO_SNDRCVTIMEO_NONSTANDARD
            int val = 5000; /* ms */
#  else
            struct timeval val = {5, 0};
#  endif
            if(setsockopt(client, SOL_SOCKET, SO_RCVTIMEO, &val, sizeof(val))==-1)
                printf("Can't set RX timeout\n");
        }
#else
        {
            static uint8_t done;
            if(!done) {
                done = 1;
                printf("INFO: SO_SNDTIMEO/SO_RCVTIMEO not supported\n");
            }
        }
#endif

        if(client==-1) {
            printf("accept error %d for port %d\n", errno, config->port);
            sys_msleep(1000);

        } else if(!(C = psc_client_alloc(PSC))) {
            printf("Dropping client %s:%d (0x%x connected)\n",
                   inet_ntoa(caddr.sin_addr.s_addr),
                   ntohs(caddr.sin_port),
                   (unsigned)PSC->clients_used);
            close(client);

        } else {
            C->sock = client;
            C->peeraddr = caddr;

            // LwIP does not allow thread creation to fail
            sys_thread_new("handle client", handle_client, C, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO); //config->client_prio);

            printf("New client %s:%d (0x%x connected)\n",
                   inet_ntoa(caddr.sin_addr.s_addr),
                   ntohs(caddr.sin_port),
                   (unsigned)PSC->clients_used);
        }
    }

    if(key)
        *key = NULL;
}

static void handle_client(void *raw)
{
    psc_client *C = raw;
    struct psc_key* PSC = C->PSC;
    int sock = C->sock;

    printf("In handle_client...\n");

    if(PSC->conf->conn)
        (*PSC->conf->conn)(PSC->conf->pvt, PSC_CONN, C);

    while(1) {
        uint16_t msgid;
        uint32_t msglen = sizeof(C->rxbuf);
        if(psc_recvmsg(sock, &msgid, C->rxbuf, &msglen, 0))
            break; /* read error */

        //function call to the recv function (which is client message)
        (*PSC->conf->recv)(PSC->conf->pvt, C, msgid, msglen, C->rxbuf);
    }

    if(PSC->conf->conn)
        (*PSC->conf->conn)(PSC->conf->pvt, PSC_DIS, C);

    printf("client disconnect %s:%d (0x%x connected)\n",
           inet_ntoa(C->peeraddr.sin_addr.s_addr),
           ntohs(C->peeraddr.sin_port),
           (unsigned)PSC->clients_used);

    psc_client_free(C);
    sys_mutex_lock(&PSC->sendguard);
    close(sock);
    sys_mutex_unlock(&PSC->sendguard);

    vTaskDelete(NULL);
}


void psc_send(psc_key *PSC, uint16_t msgid, uint32_t msglen, const void *msg)
{
    if(!PSC)
        return;
    sys_mutex_lock(&PSC->sendguard);
    for(unsigned idx=0; idx<PSC_MAX_CLIENTS; idx++) {
        int ret;
        psc_client *C = &PSC->clients[idx];

        if(!(PSC->clients_used & (1u<<idx)) || C->sock == -1)
            continue;

        ret = psc_sendmsg(C->sock, msgid, msg, msglen, 0);
        if(ret) {
            printf("%s senderror errno=%d\n", __FUNCTION__, errno);
            /* client error */
            close(C->sock); /* will wake up RX thread */
            C->sock = -1;
        }
    }
    sys_mutex_unlock(&PSC->sendguard);
}

void psc_send_one(psc_client *C, uint16_t msgid, uint32_t msglen, const void *msg)
{
    sys_mutex_lock(&C->PSC->sendguard);
    if(C->sock != -1) {
        int ret = psc_sendmsg(C->sock, msgid, msg, msglen, 0);
        if(ret) {
            printf("%s senderror errno=%d\n", __FUNCTION__, errno);
            /* client error */
            close(C->sock); /* will wake up RX thread */
            C->sock = -1;
        }
    }
    sys_mutex_unlock(&C->PSC->sendguard);
}
