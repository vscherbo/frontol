#!/bin/sh

PG_SRV=vm-pg-devel.arc.world
EXP_FILE=frontol_export-2018-05-10.txt

res=`psql -At -h $PG_SRV -U arc_energo -c 'SELECT max(ft_id)+1 FROM frontol_trans;'`

echo res=$res

skip=`awk -F';' '$1 == '$res' {print NR}' $EXP_FILE`
skip=${skip:-4}

echo skip=$skip

tail -n +$skip $EXP_FILE | psql -h vm-pg-devel -U arc_energo -c "\\copy frontol_trans from STDIN with (format 'csv', delimiter ';', header False)" 
