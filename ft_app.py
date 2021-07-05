#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
    A data exchange with Frontol 5
"""

import logging
import pg_app

LOG_FORMAT = '[%(filename)-21s:%(lineno)4s - %(funcName)20s()]\
 %(levelname)-7s | %(asctime)-15s | %(message)s'


class FTapp(pg_app.PGapp):
    """ class for Frontol app
    """

    def get_last_ft_num(self):
        """ query last_ft_num from PG
        """
        loc_ft_num = None
        while True:
            if self.do_query('SELECT ft_id FROM cash.frontol_trans order by ft_id desc limit 1;',
                             reconnect=True):
                break
        loc_ft_num = self.curs.fetchone()[0]
        return loc_ft_num

def main():
    """ just main
    """
    ft_app = FTapp('vm-pg-devel.arc.world', 'arc_energo')
    # password='XXXX' - .pgpass
    ft_app.wait_pg_connect()
    last_num = ft_app.get_last_ft_num()
    logging.info('last_num=%s', last_num)


if __name__ == '__main__':
    LOG_DIR = './'
    logging.basicConfig(filename=LOG_DIR + '/ft_app.log', format=LOG_FORMAT,
                        level=logging.DEBUG)
    logging.info('config read')
    main()
