# nginx-reverse-proxy

This is configuration for nginx reverse proxy.

## Local Setup
 * Create `.env` file using `.env.template` as template.
 * Run `nginx` locally using `docker-compose`.

```shell
source .env && docker compose up --build
docker compose down
```

## Reference

 * https://github.com/docker-library/docs/tree/master/nginx
