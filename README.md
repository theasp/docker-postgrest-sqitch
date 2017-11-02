# docker-postgrest-sqitch

Run [PostgREST](https://postgrest.com/) after deploying a schema using [Sqitch](http://sqitch.org/), based on the [offical PostgREST image](https://hub.docker.com/r/postgrest/postgrest/).

Add your Sqitch configuration to `/sqitch` by building a new image, or by mounting a volume.  The schema will be deployed to `PGRST_DB_URI`.

# Environment Variables

- `PGRST_DB_URI` - Database URI (Required)
- `SQITCH_DEPLOY` - The sqitch command to use to deploy (default "deploy")
- `SQITCH_VERIFY` - The sqitch command to use to verify, or skip on empty string (default "verify")

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

  postgres:
    image: postgres
    restart: always
    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: mydb
      POSTGRES_PASSWORD: mydb
```
