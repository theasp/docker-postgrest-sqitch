#!/bin/sh

set -e

do_sqitch() {
  sqitch status -t postgrest || true
  sqitch ${SQITCH_DEPLOY:-deploy} -t postgrest
  if [ "${SQITCH_VERIFY}" ]; then
    sqitch ${SQITCH_VERIFY} -t postgrest
  fi
}

mkdir -p ~/.sqitch
cat > ~/.sqitch/sqitch.conf <<EOF
[core]
  engine = pg

[target "postgrest"]
  uri = ${PGRST_DB_URI:-db:pg://}
EOF

if [ -e /sqitch/sqitch.plan ]; then
  if ! (cd /sqitch && do_sqitch); then
    RC=$?

    if [ ${SQITCH_REQUIRED:-true} = true ]; then
      exit $RC
    fi
  fi
fi

exec postgrest /etc/postgrest.conf
