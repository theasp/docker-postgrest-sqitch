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

SQITCH_DIR=/sqitch
SQITCH_PLAN=$SQITCH_DIR/sqitch.plan

if [ -e $SQITCH_PLAN ]; then
  if [ ${SQITCH_REQUIRED:-auto} = auto ]; then
    SQITCH_REQUIRED=true
  fi

  if ! (cd $SQITCH_DIR && do_sqitch); then
    RC=$?

    if [ ${SQITCH_REQUIRED} = true ]; then
      echo "ERROR: Sqitch returned $RC" 1>&2
      exit $RC
    else
      echo "WARNING: Sqitch returned $RC" 1>&2
    fi
  fi
else
  if [ ${SQITCH_REQUIRED} = true ]; then
    echo "ERROR: Missing $SQITCH_PLAN" 1>&2
    exit 1
  else
    echo "WARNING: Missing $SQITCH_PLAN" 1>&2
  fi
fi

# Add support for PGRST_QUIET
if [ -n ${PGRST_QUIET} ] && ! grep -q ^quiet /etc/postgrest.conf; then
  echo 'quiet = "${PGRST_QUIET}"' >> /etc/postgrest.conf
fi

exec postgrest /etc/postgrest.conf $PGRST_ARGS
