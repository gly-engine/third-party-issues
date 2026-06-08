#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include <libwebsockets.h>
#include <uv.h>

static struct lws_context *ctx;
static char host[128];
static int  port;
static char device[64];
static int  interval_ms = 1000;
static int  toggle;
static lws_sorted_usec_list_t sul;

struct req {
    char   body[160];
    size_t len;
    int    status;
    char   resp[1024];
    size_t resp_len;
};

static void tick(lws_sorted_usec_list_t *s);

static void schedule_next(void)
{
    lws_sul_schedule(ctx, 0, &sul, tick, (lws_usec_t)interval_ms * 1000);
}

static int callback_http(struct lws *wsi, enum lws_callback_reasons reason,
                         void *user, void *in, size_t len)
{
    struct req *r = (struct req *)user;

    switch (reason) {

    case LWS_CALLBACK_ESTABLISHED_CLIENT_HTTP:
        r->status = (int)lws_http_client_http_response(wsi);
        break;

    case LWS_CALLBACK_CLIENT_APPEND_HANDSHAKE_HEADER: {
        unsigned char **p = (unsigned char **)in;
        unsigned char  *end = *p + len - 1;
        char cl[24];
        int  n = snprintf(cl, sizeof cl, "%zu", r->len);
        if (lws_add_http_header_by_token(wsi, WSI_TOKEN_HTTP_CONTENT_LENGTH,
                (unsigned char *)cl, n, p, end))
            return -1;
        if (lws_add_http_header_by_token(wsi, WSI_TOKEN_HTTP_CONTENT_TYPE,
                (unsigned char *)"application/json", 16, p, end))
            return -1;
        lws_client_http_body_pending(wsi, 1);
        lws_callback_on_writable(wsi);
        break;
    }

    case LWS_CALLBACK_CLIENT_HTTP_WRITEABLE: {
        unsigned char buf[LWS_PRE + 160];
        memcpy(buf + LWS_PRE, r->body, r->len);
        lws_write(wsi, buf + LWS_PRE, r->len, LWS_WRITE_HTTP_FINAL);
        lws_client_http_body_pending(wsi, 0);
        break;
    }

    case LWS_CALLBACK_RECEIVE_CLIENT_HTTP: {
        char b[2048];
        char *pb = b;
        int   bl = sizeof b;
        if (lws_http_client_read(wsi, &pb, &bl) < 0)
            return -1;
        break;
    }

    case LWS_CALLBACK_RECEIVE_CLIENT_HTTP_READ: {
        size_t room = sizeof r->resp - 1 - r->resp_len;
        size_t cpy  = len < room ? len : room;
        if (cpy) {
            memcpy(r->resp + r->resp_len, in, cpy);
            r->resp_len += cpy;
        }
        break;
    }

    case LWS_CALLBACK_COMPLETED_CLIENT_HTTP:
        r->resp[r->resp_len] = '\0';
        lwsl_user("OK status=%d body=%s\n", r->status, r->resp);
        break;

    case LWS_CALLBACK_CLOSED_CLIENT_HTTP:
        free(r);
        schedule_next();
        break;

    case LWS_CALLBACK_CLIENT_CONNECTION_ERROR:
        lwsl_user("FAIL %s\n", in ? (char *)in : "?");
        free(r);
        schedule_next();
        break;

    default:
        break;
    }

    return 0;
}

static const struct lws_protocols protocols[] = {
    { "http", callback_http, 0, 0, 0, NULL, 0 },
    { NULL, NULL, 0, 0, 0, NULL, 0 }
};

static void tick(lws_sorted_usec_list_t *s)
{
    (void)s;
    struct req *r = calloc(1, sizeof *r);
    const char *sw = (toggle ^= 1) ? "on" : "off";
    r->len = snprintf(r->body, sizeof r->body,
        "{\"deviceid\":\"%s\",\"data\":{\"switch\":\"%s\"}}", device, sw);

    lwsl_user("-> %s\n", sw);

    struct lws_client_connect_info i;
    memset(&i, 0, sizeof i);
    i.context  = ctx;
    i.address  = host;
    i.port     = port;
    i.path     = "/zeroconf/switch";
    i.host     = host;
    i.origin   = host;
    i.method   = "POST";
    i.protocol = "http";
    i.userdata = r;

    if (!lws_client_connect_via_info(&i)) {
        lwsl_user("connect fail\n");
        free(r);
        schedule_next();
    }
}

int main(int argc, char **argv)
{
    if (argc < 2 ||
        sscanf(argv[1], "%127[^:]:%d:%63s", host, &port, device) != 3) {
        fprintf(stderr, "usage: %s <ip>:<port>:<device> [interval_ms]\n", argv[0]);
        return 1;
    }
    if (argc > 2)
        interval_ms = atoi(argv[2]);
    if (interval_ms <= 0)
        interval_ms = 1000;

    lws_set_log_level(LLL_USER | LLL_ERR | LLL_WARN, NULL);

    uv_loop_t loop;
    uv_loop_init(&loop);
    void *foreign[1] = { &loop };

    struct lws_context_creation_info info;
    memset(&info, 0, sizeof info);
    info.port          = CONTEXT_PORT_NO_LISTEN;
    info.protocols     = protocols;
    info.options       = LWS_SERVER_OPTION_LIBUV;
    info.foreign_loops = foreign;

    ctx = lws_create_context(&info);
    if (!ctx) {
        fprintf(stderr, "context failed\n");
        return 1;
    }

    lws_sul_schedule(ctx, 0, &sul, tick, 1);

    uv_run(&loop, UV_RUN_DEFAULT);

    lws_context_destroy(ctx);
    uv_loop_close(&loop);
    return 0;
}
