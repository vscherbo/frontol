#!/bin/sh

#DT_START=2022-11-28
DT_START=$1
DT_END=$DT_START
#DT_END=2022-11-28 

./ucs_xml_report.py --log_level=INFO --dt_start=$DT_START # --dt_end=$DT_END
./parse_ucs.py --xml=01-xml/report_txn_grp_txn_${DT_START}_${DT_END}.xml > rep.csv
psql -h vm-pg.arc.world -U arc_energo -f rep.sql
