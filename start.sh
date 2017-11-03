#!/bin/sh

set -e

PGRST_DB_URI="${PGRST_DB_URI:-pg://}"

do_sqitch() {
  sqitch status "db:${PGRST_DB_URI}" || true
  sqitch ${SQITCH_DEPLOY:-deploy} "db:${PGRST_DB_URI}"
  if [ "${SQITCH_VERIFY}" ]; then
    sqitch ${SQITCH_VERIFY} "db:${PGRST_DB_URI}"
  fi
}

mkdir -p ~/.sqitch
cat > ~/.sqitch/sqitch.conf <<EOF
[core]
  engine = pg
EOF

set -x

if [ -e /sqitch/sqitch.plan ]; then
  if ! (cd /sqitch && do_sqitch); then
    RC=$?

    if [ ${SQITCH_REQUIRED:-true} = true ]; then
      exit $RC
    fi
  fi
fi

exec postgrest /etc/postgrest.conf
