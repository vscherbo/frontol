#!/bin/sh

DST=/opt/atol/export_catalog

psql -U arc_energo -f copy_frontol_catalog2csv.sql |sed -r -e 's/["]{0,1};["]{0,1}/;/g' -e 's/""/"/g' |unix2dos| iconv -f utf8 -t cp1251//TRANSLIT -o $DST/frontol_catalog.txt 

touch $DST/frontol_catalog_flag.txt

