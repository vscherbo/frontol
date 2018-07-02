#!/bin/sh

. /usr/local/bin/bashlib

FLAG_DIR=/opt/atol/export_catalog
FLAG_FILE=$FLAG_DIR/frontol_receipts_flag.txt

[ -f $FLAG_FILE ] && { logmsg INFO "Previous $FLAG_FILE exists. Exiting"; exit 0; }

EXPECT_FLAG=`psql -qtAX -U arc_energo -c 'select exists (select * from cash.receipt_queue where status=0);'`
logmsg INFO "EXPECT_FLAG=$EXPECT_FLAG"

if [ +t == +$EXPECT_FLAG ]
then
    echo '$$$NEWTRANSACTIONS' > $FLAG_FILE
fi

