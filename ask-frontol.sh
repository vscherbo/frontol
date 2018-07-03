#!/bin/sh

. /usr/local/bin/bashlib

BASE_DIR=/opt/atol
FLAG_DIR=$BASE_DIR/export_catalog
FLAG_FILE=$FLAG_DIR/frontol_receipts_flag.txt
LOG_DIR=$BASE_DIR/logs
LOG=$LOG_DIR/`basename $0`.log
[ -d $LOG_DIR ] || mkdir -p $LOG_DIR

exec 1>>$LOG 2>&1

[ -f $FLAG_FILE ] && { logmsg INFO "Previous $FLAG_FILE exists. Exiting"; exit 0; }

EXPECT_FLAG=`/usr/bin/psql -qtAX -U arc_energo -c 'select exists (select * from cash.receipt_queue where status=0);'`
logmsg INFO "EXPECT_FLAG=$EXPECT_FLAG"

if [ +t == +$EXPECT_FLAG ]
then
    echo '$$$NEWTRANSACTIONS' > $FLAG_FILE
fi

