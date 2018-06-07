#!/bin/sh

psql -h vm-pg-devel -U arc_energo -f sql/copy_frontol_catalog2csv.sql |sed -r -e 's/["]{0,1};["]{0,1}/;/g' -e 's/""/"/g' |unix2dos| iconv -f utf8 -t cp1251//TRANSLIT -o /smb/it/ATOL/load-unload/frontol_catalog.txt
