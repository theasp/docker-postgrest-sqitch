# docker-postgrest-sqitch

Run [PostgREST](https://postgrest.com/) after deploying a schema using [Sqitch](http://sqitch.org/), based on the [offical PostgREST image](https://hub.docker.com/r/postgrest/postgrest/).

Add your Sqitch configuration to `/sqitch` by building a new image, or by mounting a volume.  The schema will be deployed to `PGRST_DB_URI`.

# Environment Variables

- `PGRST_DB_URI` (required) - Database URI
- `SQITCH_DEPLOY` (default `deploy`) - The sqitch command to use to deploy.  You can use this to pass arguments as well, for example `deploy --verify`.
- `SQITCH_VERIFY` (default `verify`) - The sqitch command to use to verify, or skip on empty string.
- `SQITCH_REQUIRED` (default `auto`) - If set to `true`, postgrest will not be started if there is a problem with sqitch.  If set to `auto` then sqitch will be skipped if there is no `sqitch.plan` available.

# Example `Dockerfile`

```dockerfile
FROM theasp/postgrest-sqitch
ADD ./ /sqitch
```

# Example `docker-compose.yml`
```yaml
---
version: '3'

services:
  postgrest:
    image: mydb-postgrest
    build: .
    ports:
      - "3000:3000"
    restart: always
    environment:
      PGRST_DB_URI: postgres://mydb:mydb@postgres:5432/mydb
      PGRST_DB_SCHEMA: public
      PGRST_DB_ANON_ROLE: anonymous
      PGRST_SERVER_PROXY_URI: http://localhost:3000
      SQITCH_DEPLOY: deploy --verify

  postgres:
    image: postgres
    restart: always
    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: mydb
      POSTGRES_PASSWORD: mydb
```
