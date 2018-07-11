#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import time
import logging
import configparser
from watchdog.observers import Observer
from watchdog.events import PatternMatchingEventHandler
import psycopg2
import io
import shutil
import os

log_format = '[%(filename)-21s:%(lineno)4s - %(funcName)20s()] %(levelname)-7s | %(asctime)-15s | %(message)s'

def remove_file(filename):
    try:
        os.remove(filename) 
        logging.info('removed {}'.format(filename)) 
    except:
        logging.exception('remove failed')

def move_file(src, dst):
    try:
        shutil.move(src, dst) 
        logging.info('moved {} to {}'.format(src, dst)) 
    except:
        logging.exception('move failed')


def import_trans():
    try:
        src_file = trans_dir + '/frontol_receipts.txt'
        out_file = csv_dir + '/output.csv'
        with open(src_file, 'r', encoding="cp1251") as t, open(out_file, 'w') as fcsv :
            csv_list = []
            lines = t.readlines()
            report_num = int(lines[2].strip())
            logging.info('report_num={}'.format(report_num))
            for l in lines[3:]:
                d = l.strip().replace(',', '.').split(';')  # decimal point instead of ','
                fields = ';'.join(d[0:7])
                tail = ','.join(d[7:])
                csv_l = "{};{}".format(fields, tail)
                fcsv.write(csv_l + '\n')
                csv_list.append(csv_l)
        logging.info(csv_list)
        csv_io = io.StringIO('\n'.join(csv_list))
        try:
            curs.copy_expert("COPY cash.frontol_trans FROM STDIN WITH CSV delimiter ';';", csv_io)
            conn.commit()
            logging.info('\COPY commited')
        except Exception:
            logging.exception('\COPY command')
            move_file(out_file, '{}/output-failed.csv-{:08}'.format(archive_dir, report_num)) 
        else: # \COPY commited
            remove_file(out_file)
            move_file(src_file, '{}/frontol_receipts.txt-{:08}'.format(archive_dir, report_num)) 
    except Exception:
        logging.exception('import_trans')

class FT_flag_handler(PatternMatchingEventHandler):
    # patterns = ["*/frontol_*_flag.txt"]
    patterns = ["*"]

    def process(self, event):
        """
        event.event_type 
            'modified' | 'created' | 'moved' | 'deleted'
        event.is_directory
            True | False
        event.src_path
            path/to/observed/file
        """
        # the file will be processed there
        if not event.is_directory:
            logging.info('file {} {}'.format(event.src_path, event.event_type))
        if 'frontol_receipts_flag.txt' in event.src_path \
           and (event.event_type == 'moved' or event.event_type == 'deleted'):
            logging.info('start import transactions')
            import_trans()

    def on_modified(self, event):
        self.process(event)

    def on_moved(self, event):
        self.process(event)

    def on_created(self, event):
        self.process(event)

    def on_deleted(self, event):
        self.process(event)

if __name__ == '__main__':
    conf_file_name = "ftd.conf"
    config = configparser.ConfigParser(allow_no_value=True)
    config.read(conf_file_name)
    watch_dir = config['dirs']['watch_dir']
    trans_dir = config['dirs']['trans_dir']
    csv_dir = config['dirs']['csv_dir']
    log_dir = config['dirs']['log_dir']
    archive_dir = config['dirs']['archive_dir']
    numeric_level = logging.INFO
    logging.basicConfig(filename=log_dir + '/ftd.log', format=log_format, level=numeric_level)
    logging.info('config read')

    observer = Observer()
    observer.schedule(FT_flag_handler(), path=watch_dir)
    observer.start()

    pg_srv = config['PG']['pg_srv']
    conn = psycopg2.connect("host='{}' dbname='arc_energo' user='arc_energo'".format(pg_srv))  # password='XXXX' - .pgpass
    conn.set_session(autocommit=True)
    curs = conn.cursor()
    logging.info('PG {} connected'.format(pg_srv))

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        logging.info('Exiting')
        observer.stop()

    observer.join()
