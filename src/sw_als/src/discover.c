
#include <stdio.h>

#include <lwip/tcpip.h>
#include <lwip/udp.h>

#include "local.h"

static
struct udp_pcb *disco_pcb;

// the PBUF_ROM appended to all replies
static
struct pbuf* disco_reply_buf;

static
void disco_recv(void *arg, struct udp_pcb *pcb, struct pbuf *p,
                const ip_addr_t *addr, u16_t port)
{
    (void)arg;

    struct {
        char P, S;
        uint16_t msgid;
        uint32_t msglen;
        union {
            uint16_t sn;
        } body;
    } msg;
    u16_t n = pbuf_copy_partial(p, &msg, sizeof(msg), 0u);

    if(n<8u || msg.P!='P' || msg.S!='S')
        return; // ignore invalid header

    msg.msgid = ntohs(msg.msgid);
    msg.msglen = ntohl(msg.msglen);

    if(n-8u < msg.msglen)
        return; // truncated body?

    if(msg.msgid != 1234)
        return; // not interesting

    if(msg.msglen >= sizeof(msg.body.sn) && msg.body.sn!=0) {
        uint16_t sn = ntohs(msg.body.sn);
        // TODO: filter by our serial number
        //if(sn != my_sn) return;
        (void)sn;
    }

    p = pbuf_alloc(PBUF_TRANSPORT, 0, PBUF_RAM);
    if(p) {
        pbuf_chain(p, disco_reply_buf); // inc. ref count for disco_reply_buf

        err_t err = udp_sendto(pcb, p, addr, port); // does not inc. ref count for p
        if(err != ERR_OK) {
            fprintf(stderr, "Warning %s(%d): Unable to send discover reply to %s:%u\n",
                    lwip_strerr(err), err, inet_ntoa(addr->addr), port);
        }
        pbuf_free(p);
    }
}

// runs on tcpip_thread
static
void discover_prep(void *unused)
{
    (void)unused;

    disco_pcb = udp_new_ip_type(IPADDR_TYPE_ANY);
    if(!disco_pcb) {
        fprintf(stderr, "Error: unable to allocate discovery socket\n");
        return;
    }

    err_t err = udp_bind(disco_pcb, IP_ANY_TYPE, 3000);
    if(err!=ERR_OK) {
        fprintf(stderr, "Error %d: unable to bind UDP discovery\n", err);
    }

    // static reply to discovery request
    static
    struct {
        char P, S;
        uint16_t msgid;
        uint32_t msglen;
        struct {
            uint32_t git_hash;
            uint16_t sn;
        } body;
    } disco_reply = {
        'P', 'S',
        PP_HTONS(1234),
        PP_HTONL(sizeof(disco_reply.body)),
        {}
    };
    disco_reply.body.git_hash = htonl(git_hash);
    disco_reply_buf = pbuf_alloc_reference(&disco_reply, sizeof(disco_reply), PBUF_ROM);
    if(!disco_reply_buf) {
        fprintf(stderr, "Error: unable to allocate discovery reply pbuf\n");
        return;
    }

    udp_recv(disco_pcb, disco_recv, NULL);
}

void discover_setup(void)
{
    err_t err = tcpip_callback(discover_prep, NULL);
    if(err!=ERR_OK)
        fprintf(stderr, "Error %d: unable to setup UDP discovery\n", err);
}
