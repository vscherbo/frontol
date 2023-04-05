#!/bin/sh


. /usr/local/bin/bashlib

WRK_DIR=$(dirname $0)

pushd $WRK_DIR > /dev/null
LOG=$(namename $0).log
exec 3>&1 1>>$LOG 2>&1

YESTERDAY=$(date --date='yesterday' +%F)
DT_START=${1:-$YESTERDAY}
#DT_END=$(date --date="$DT_START + 1day" +%F)
DT_END=$DT_START

$HOME/.pyenv/shims/python ./ucs_xml_report.py --log_level=INFO --dt_start=$DT_START --dt_end=$DT_END
$HOME/.pyenv/shims/python ./parse_ucs.py --xml=01-xml/report_txn_grp_txn_${DT_START}_${DT_END}.xml > rep.csv
psql -h vm-pg.arc.world -U arc_energo -f rep.sql

