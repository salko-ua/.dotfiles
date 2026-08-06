/* Cap OpenSSL client contexts at TLS 1.2 — workaround for RDP servers
   that hang on TLS 1.3 ClientHello. Preload into remmina/xfreerdp. */
#define _GNU_SOURCE
#include <dlfcn.h>
#include <stddef.h>

#define SSL_CTRL_SET_MAX_PROTO_VERSION 124
#define TLS1_2_VERSION 0x0303

typedef struct ssl_ctx_st SSL_CTX;
typedef struct ssl_method_st SSL_METHOD;

long SSL_CTX_ctrl(SSL_CTX *ctx, int cmd, long larg, void *parg)
{
    static long (*real)(SSL_CTX *, int, long, void *);
    if (!real) real = dlsym(RTLD_NEXT, "SSL_CTX_ctrl");
    if (cmd == SSL_CTRL_SET_MAX_PROTO_VERSION && (larg == 0 || larg > TLS1_2_VERSION))
        larg = TLS1_2_VERSION;
    return real(ctx, cmd, larg, parg);
}

SSL_CTX *SSL_CTX_new(const SSL_METHOD *m)
{
    static SSL_CTX *(*real)(const SSL_METHOD *);
    if (!real) real = dlsym(RTLD_NEXT, "SSL_CTX_new");
    SSL_CTX *ctx = real(m);
    if (ctx)
        SSL_CTX_ctrl(ctx, SSL_CTRL_SET_MAX_PROTO_VERSION, TLS1_2_VERSION, NULL);
    return ctx;
}
