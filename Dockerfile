FROM postgrest/postgrest:latest
RUN apt-get update && apt-get install -qy libdbd-pg-perl sqitch
ADD start.sh /start.sh
CMD /start.sh
ENV SQITCH_DEPLOY=deploy SQITCH_VERIFY=verify SQITCH_REQUIRED=true
