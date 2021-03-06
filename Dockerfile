FROM postgrest/postgrest:latest
RUN set -ex; \
  sed -e 's/^deb /deb-src /' < /etc/apt/sources.list >> /etc/apt/sources.list; \
  apt-get update; \
  apt-get install -qy libdbd-pg-perl postgresql-client; \
  apt-get build-dep -qy sqitch; \
  cpan App::Sqitch
ADD start.sh /start.sh
CMD /start.sh
ENV SQITCH_DEPLOY=deploy SQITCH_VERIFY=verify SQITCH_REQUIRED=true PGRST_QUIET=false
