#!/bin/sh

[ + == +$1 ] && { echo 1st parameter \(bill_no\) is required. Exit.; exit 123; }

psql -h vm-pg-devel -U arc_energo -v bill_no=$1 -f sql/write-frontol-order.sql |unix2dos > /smb/it/ATOL/F5-import-orders/order$1.opn

