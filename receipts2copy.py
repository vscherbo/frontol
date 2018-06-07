#!/usr/bin/env python2.7
# *-* coding: utf-8 *-*

import sys

args = sys.argv[1:]
with open('trans/' + args[0], 'r') as r, open('trans/output.csv', 'w') as fcsv :
    for l in r.readlines()[3:]:
        d = l.strip().split(';')
        fields = ';'.join(d[0:7])
        tail = ','.join(d[7:])
        fcsv.write("{};{}\n".format(fields, tail))
