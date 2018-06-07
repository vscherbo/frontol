#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import time
import logging
import configparser
from watchdog.observers import Observer
from watchdog.events import PatternMatchingEventHandler

log_format = '[%(filename)-21s:%(lineno)4s - %(funcName)20s()] %(levelname)-7s | %(asctime)-15s | %(message)s'

# \copy cash.frontol_trans from 'trans/output.csv' with (format 'csv', header false, delimiter ';');

def import_trans():
    global watch_dir
    global trans_dir
    global csv_dir
    try:
        with open(trans_dir + '/frontol_receipts.txt', 'r') as t, open(csv_dir + '/output.csv', 'w') as fcsv :
            for l in t.readlines()[3:]:
                d = l.strip().split(';')
                fields = ';'.join(d[0:7])
                tail = ','.join(d[7:])
                fcsv.write("{};{}\n".format(fields, tail))
    except Exception:
        logging.exception('import_trans')

class FT_flag_handler(PatternMatchingEventHandler):
    patterns = ["*/frontol_*_flag.txt"]

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
        logging.info('file {} {}'.format(event.src_path, event.event_type))
        if 'frontol_receipts_flag.txt' in event.src_path  and event.event_type == 'modified':
            logging.info('start import transactions')
            import_trans()

    def on_modified(self, event):
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

    observer = Observer()
    observer.schedule(FT_flag_handler(), path=watch_dir)
    observer.start()
    numeric_level = logging.INFO
    logging.basicConfig(filename=log_dir + '/ftd.log', format=log_format, level=numeric_level)

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()

    observer.join()
