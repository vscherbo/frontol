#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
    A data exchange with Frontol 5
"""

import time
import logging
import configparser
import io
import shutil
import os
import psycopg2

from watchdog.observers import Observer
from watchdog.events import PatternMatchingEventHandler

LOG_FORMAT = '[%(filename)-21s:%(lineno)4s - %(funcName)20s()]\
 %(levelname)-7s | %(asctime)-15s | %(message)s'


def remove_file(filename):
    """
    try to remove a file
    """
    try:
        os.remove(filename)
        logging.info('removed %s', filename)
    except:
        logging.exception('remove failed')
        raise


def move_file(src, dst):
    """
    try to move a file
    """
    try:
        shutil.move(src, dst)
        logging.info('moved %s to %s', src, dst)
    except:
        logging.exception('move failed')
        raise

def wait_pg_connect(arg_pg):
    """
    Loop until an connection to PG is available.
    """
    global CONN
    global CURS
    while True:
        logging.info("Trying connection to PG.")
        try:
            # password='XXXX' - .pgpass
            CONN = psycopg2.connect("host='{}' dbname='arc_energo' \
user='arc_energo'".format(arg_pg))
            CONN.set_session(autocommit=True)
            CURS = CONN.cursor()
            logging.info('PG %s connected', arg_pg)
            break
        except psycopg2.Error:
            logging.warning("Connection failed. Retrying in 10 seconds")
            time.sleep(10)


def get_last_ft_num():
    """ query last_ft_num from PG
    """
    loc_ft_num = None
    try:
        CURS.execute('SELECT ft_id FROM cash.frontol_trans order by ft_id desc limit 1;')
    except psycopg2.OperationalError as exc:
        if exc.pgcode in ('57P01', '57P02', '57P03'):
            wait_pg_connect(PG_SRV)
    except psycopg2.Error as exc:
        logging.exception('PG error=%s', exc.pgcode)
    else:
        loc_ft_num = CURS.fetchone()[0]
    return loc_ft_num


def import_trans():
    """
    import Frontol transactions into PG
    """
    try:
        src_file = TRANS_DIR + '/frontol_receipts.txt'
        out_file = CSV_DIR + '/output.csv'
        csv_list = []
        with open(src_file, 'r', encoding="cp1251") as tr_file:
            lines = tr_file.readlines()

        try:
            report_num = int(lines[2].strip())
        except IndexError:
            report_num = -1
        else:
            logging.info('report_num=%s', report_num)
            while True:
                last_ft_num = get_last_ft_num()
                if last_ft_num:
                    break
            logging.info('last_ft_num=%s', last_ft_num)

            with open(out_file, 'w') as fcsv:
                for line in lines[3:]:
                    # decimal point instead of comma
                    line_fields = line.strip().replace(',', '.').split(';')
                    ft_num = line_fields[0]
                    logging.info('current ft_num=%s', ft_num)
                    if int(ft_num) <= int(last_ft_num):
                        logging.info('from PAST ft_num=%s', ft_num)
                    else:
                        fields = ';'.join(line_fields[0:7])
                        tail = ','.join(line_fields[7:])
                        csv_l = "{};{}".format(fields, tail)
                        fcsv.write(csv_l + '\n')
                        csv_list.append(csv_l)
        logging.info(csv_list)
        if csv_list:
            csv_io = io.StringIO('\n'.join(csv_list))
            try:
                CURS.copy_expert("COPY cash.frontol_trans FROM STDIN WITH\
 CSV delimiter ';';", csv_io)
                CONN.commit()
                logging.info('\\COPY commited')
            except psycopg2.OperationalError:
                logging.exception('\\COPY command')
                move_file(out_file,
                          '{}/output-failed.csv-{:08}'.format(ARCHIVE_DIR,
                                                              report_num))
            else:  # \COPY commited
                remove_file(out_file)
                move_file(src_file,
                          '{}/frontol_receipts.txt-{:08}'.format(ARCHIVE_DIR,
                                                                 report_num))
        else:
            logging.info('An empty csv_list, skipping')
            remove_file(out_file)
            move_file(src_file,
                      '{}/frontol_receipts.txt-{:08}'.format(ARCHIVE_DIR,
                                                             report_num))
    except:
        logging.exception('import_trans')
        raise


class FrontolFlagHandler(PatternMatchingEventHandler):
    """
    A handler of frontol's flag files
    """
    # patterns = ["*/frontol_*_flag.txt"]
    patterns = ["*"]

    def __init__(self):
        super(FrontolFlagHandler, self).__init__(ignore_directories=True)
        self.frontol_receipts_flag = 'frontol_receipts_flag.txt'

    def process(self, event):
        """
        event.event_type
            'modified' | 'created' | 'moved' | 'deleted'
        event.is_directory
            True | False
        event.src_path
            path/to/observed/file
        """

        """ needless cause ignore_directories=True
        if not event.is_directory:
            logging.info('file %s %s', event.src_path, event.event_type)
        """
        # the file will be processed there
        logging.info('file %s %s', event.src_path, event.event_type)
        # if 'frontol_receipts_flag.txt' in event.src_path \
        if self.frontol_receipts_flag in event.src_path \
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
    CONF_FILE_NAME = "ftd.conf"
    CONFIG = configparser.ConfigParser(allow_no_value=True)
    CONFIG.read(CONF_FILE_NAME)
    WATCH_DIR = CONFIG['dirs']['watch_dir']
    TRANS_DIR = CONFIG['dirs']['trans_dir']
    CSV_DIR = CONFIG['dirs']['csv_dir']
    LOG_DIR = CONFIG['dirs']['log_dir']
    ARCHIVE_DIR = CONFIG['dirs']['archive_dir']
    NUMERIC_LEVEL = logging.INFO
    logging.basicConfig(filename=LOG_DIR + '/ftd.log', format=LOG_FORMAT,
                        level=NUMERIC_LEVEL)
    logging.info('config read')

    OBSERVER = Observer()
    OBSERVER.schedule(FrontolFlagHandler(), path=WATCH_DIR)
    OBSERVER.start()

    PG_SRV = CONFIG['PG']['PG_SRV']
    CONN = None
    CURS = None
    # password='XXXX' - .pgpass
    wait_pg_connect(PG_SRV)

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        logging.info('Exiting')
        OBSERVER.stop()

    OBSERVER.join()
