#ifndef PSCSERVER_H
#define PSCSERVER_H

#include <inttypes.h>
#include <stdarg.h>

#include <lwip/sockets.h>

#if !LWIP_SOCKET
# error LWIP Sockets required
#endif
#if NO_SYS
# error LWIP NO_SYS not supported
#endif

typedef struct psc_key psc_key;
typedef struct psc_client psc_client;

typedef enum {
  PSC_CONN, PSC_DIS
} psc_event;

/* Called once the server is running */
typedef void (*psc_start)(void *pvt, psc_key *key);
/* Called when a client (dis)connects */
typedef void (*psc_conn)(void *pvt, psc_event evt, psc_client *ckey);
/* Called when a message is received */
typedef void (*psc_recv)(void *pvt, psc_client *ckey, uint16_t msgid, uint32_t msglen, void *msg);

typedef struct {
    void *pvt;
    unsigned short port;
    psc_conn conn;
    psc_recv recv;
    psc_start start;

    int client_prio; /* eg. DEFAULT_THREAD_PRIO */
} psc_config;

void psc_run(psc_key **key, const psc_config *config);

void psc_send(psc_key *key, uint16_t msgid, uint32_t msglen, const void *msg);
void psc_send_one(psc_client *key, uint16_t msgid, uint32_t msglen, const void *msg);

void psc_error(psc_key *key, int code, const char *fmt, ...) __attribute__((format(printf,3,4)));
void psc_verror(psc_key *key, int code, const char *fmt, va_list args);

#endif // PSCSERVER_H
