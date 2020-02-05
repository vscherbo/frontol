#!/usr/bin/env python3
"""
    A data exchange with Frontol 5
"""

import time
import logging
import configparser
import io
import shutil
import os

from watchdog.observers import Observer
from watchdog.events import PatternMatchingEventHandler

import ft_app

LOG_FORMAT = '[%(filename)-21s:%(lineno)4s - %(funcName)20s()]\
 %(levelname)-7s | %(asctime)-15s | %(message)s'

class FTImportTrans(ft_app.FTapp):
    """ Class importing csv file with transactions """
    def __init__(self, pg_host, pg_user):
        self.lines = []
        self.csv_list = []
        super(FTImportTrans, self).__init__(pg_host, pg_user)

    def open_src(self, src_file):
        """ Open and read in lines[] src_file
            return True if read with success
        """
        do_open = True
        cnt = 0
        self.lines = []
        result = False
        while do_open:
            try:
                with open(src_file, 'r', encoding="cp1251") as tr_file:
                    self.lines = tr_file.readlines()
                result = True
            except OSError:
                logging.exception("Could not open/read file: %s", src_file)
                cnt = cnt + 1
                time.sleep(10)
                do_open = cnt < 3
            else:
                do_open = False

        """
        with open(src_file, 'r', encoding="cp1251") as tr_file:
            lines = tr_file.readlines()
        """
        return result

    @property
    def last_ft_num(self):
        """ Returns last written to PG ft_num """
        while True:
            _last_ft_num = FT_APP.get_last_ft_num()
            if _last_ft_num:
                break
        logging.info('_last_ft_num=%s', _last_ft_num)
        return _last_ft_num

    @property
    def report_num(self):
        """ Returns a report num """
        try:
            local_report_num = int(self.lines[2].strip())
        except IndexError:
            local_report_num = -1
        return local_report_num

    def create_csv_out(self, out_file):
        """ Parse lines and write onto CSV file
        """
        self.csv_list = []
        with open(out_file, 'w') as fcsv:
            for line in self.lines[3:]:
                # decimal point instead of comma
                line_fields = line.strip().replace(',', '.').split(';')
                ft_num = line_fields[0]
                logging.info('current ft_num=%s', ft_num)
                if int(ft_num) <= int(self.last_ft_num):
                    logging.info('from PAST ft_num=%s', ft_num)
                else:
                    fields = ';'.join(line_fields[0:7])
                    tail = ','.join(line_fields[7:])
                    csv_l = "{};{}".format(fields, tail)
                    fcsv.write(csv_l + '\n')
                    self.csv_list.append(csv_l)
        logging.info(self.csv_list)
        return self.csv_list



################################################################################

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


def import_trans():
    """
    import Frontol transactions into PG
    """
    try:
        src_file = TRANS_DIR + '/frontol_receipts.txt'
        out_file = CSV_DIR + '/output.csv'
        csv_list = []

        if not FT_APP.open_src(src_file):
            logging.warning('Failed open file %s', src_file)
            return

        if FT_APP.report_num > 0:
            logging.info('report_num=%s', FT_APP.report_num)

        csv_list = FT_APP.create_csv_out(out_file)
        if csv_list:
            csv_io = io.StringIO('\n'.join(csv_list))
            try:
                FT_APP.copy_expert("COPY cash.frontol_trans FROM STDIN WITH\
                        CSV delimiter ';';", csv_io)
            except ft_app.pg_app.PGException:
                logging.exception('COPY cash.frontol_trans')
                move_file(out_file,
                          '{}/output-failed.csv-{:08}'.format(ARCHIVE_DIR,
                                                              FT_APP.report_num))
            else:
                remove_file(out_file)
            finally:
                move_file(src_file, '{}/frontol_receipts.txt-{:08}'.format(\
                        ARCHIVE_DIR, FT_APP.report_num))
        else:
            logging.info('An empty csv_list, skipping')
            # out_file was not created
            # remove_file(out_file)
            move_file(src_file,
                      '{}/frontol_receipts.txt-{:08}'.format(ARCHIVE_DIR,
                                                             FT_APP.report_num))
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

        """ It is needless because ignore_directories=True
        if not event.is_directory:
            logging.info('file %s %s', event.src_path, event.event_type)
        """
        # the file will be processed there
        logging.info('file %s %s', event.src_path, event.event_type)
        # if 'frontol_receipts_flag.txt' in event.src_path \
        if self.frontol_receipts_flag in event.src_path \
           and (event.event_type == 'moved' or event.event_type == 'deleted'):
            time.sleep(5)
            logging.info('start import transactions')
            #try:
            import_trans()
            #except:
            #    logging.info('import_trans() failed')
                #raise

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
    #FT_APP = ft_app.FTapp(PG_SRV, CONFIG['PG']['USER_NAME'])
    FT_APP = FTImportTrans(PG_SRV, CONFIG['PG']['USER_NAME'])
    FT_APP.wait_pg_connect()
    #CONN = None
    #CURS = None
    # password='XXXX' - .pgpass
    #wait_pg_connect(PG_SRV)

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        logging.info('Exiting')
        OBSERVER.stop()

    OBSERVER.join()
