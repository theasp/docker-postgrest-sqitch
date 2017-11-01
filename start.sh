#!/bin/sh

set -e

mkdir -p ~/.sqitch
cat > ~/.sqitch/sqitch.conf <<EOF
[core]
  engine = pg

[target "postgrest"]
  uri = ${PGRST_DB_URI:-db:pg://}
EOF

if [ -e /sqitch/sqitch.plan ]; then
  (
    cd /sqitch
    sqitch status -t postgrest || true
    sqitch deploy -t postgrest
    if [ "${SQITCH_VERIFY:-true}" = true ]; then
      sqitch verify -t postgrest
    fi
  )
fi

exec postgrest /etc/postgrest.conf
