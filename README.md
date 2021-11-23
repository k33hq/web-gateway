# prerender-nginx-proxy

This is configuration for nginx reverse proxy for server-side rendering using prerender.io service.

This reverse proxy intercepts requests from crawler bots based on `User-Agent` header and forwards them to prerender.io service.

The requests from real users should otherwise be forwarded to backend service.

## Local Setup
 * Create an account in prerender.io and use TOKEN provided.
 * Create `.env` file using `example.env` as template.
 * Run `nginx` locally using `docker-compose`.

```shell
source .env && docker compose up --build
docker compose down
```

## Reference

 * https://github.com/docker-library/docs/tree/master/nginx
 * https://github.com/prerender/prerender-nginx/blob/master/nginx-reverse-proxy/nginx.conf
