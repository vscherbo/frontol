#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import time
import sys
import logging
from watchdog.observers import Observer
from watchdog.events import PatternMatchingEventHandler

log_format = '[%(filename)-21s:%(lineno)4s - %(funcName)20s()] %(levelname)-7s | %(asctime)-15s | %(message)s'

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

    def on_modified(self, event):
        self.process(event)

    def on_created(self, event):
        self.process(event)

    def on_deleted(self, event):
        self.process(event)

if __name__ == '__main__':
    args = sys.argv[1:]
    observer = Observer()
    observer.schedule(FT_flag_handler(), path=args[0] if args else '.')
    observer.start()
    numeric_level = logging.INFO
    logging.basicConfig(filename='ft.log', format=log_format, level=numeric_level)

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()

    observer.join()
