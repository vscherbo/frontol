#!/bin/sh


. /usr/local/bin/bashlib

WRK_DIR=$(dirname $0)
LOG=$(namename $0).log
exec 1>>$LOG 2>&1

pushd $WRK_DIR

#DT_START=2022-11-28
DT_START=$1
DT_END=$DT_START
#DT_END=2022-11-28 

/root/.pyenv/shims/python3 ./ucs_xml_report.py --log_level=INFO --dt_start=$DT_START # --dt_end=$DT_END
/root/.pyenv/shims/python3 ./parse_ucs.py --xml=01-xml/report_txn_grp_txn_${DT_START}_${DT_END}.xml > rep.csv
psql -h vm-pg.arc.world -U arc_energo -f rep.sql
