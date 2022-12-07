#!/usr/bin/env python
""" Parse XML from UCS """
import warnings
from bs4 import BeautifulSoup
from bs4.builder import XMLParsedAsHTMLWarning

import log_app

ATTRS = ["acc_key", "authcode", "card_mask", "ct_id", "exp_comm", "gross_amount",
         "grp_date", "ind_data", "pc_key", "slip_no", "term_id", "txn_date", "txn_type"]

COPY_SQL = """\copy cash.ucs_register_tmp({}) from 'rep.csv' with(format 'csv', header True, delimiter '^');\n"""

class UcsApp(log_app.LogApp):
    """ Main capp class"""
    def __init__(self, args):
        #log_app.LogApp.__init__(self, args=args)
        super(UcsApp, self).__init__(args=args)
        warnings.filterwarnings('ignore', category=XMLParsedAsHTMLWarning)
        self.xml = args.xml
        self.csv = 'rep.csv'
        self.sql = 'rep.sql'

    def prep_import(self):
        """ parse xml and write csv"""
        with open(self.xml) as inpf:
            xml_root = BeautifulSoup(inpf, "lxml")
            attrs = ','.join(ATTRS)
            txns = ['^'.join(ATTRS)]
            print('^'.join(ATTRS))
            for txn in xml_root.find_all('txn'):
                csv = []
                for attr in ATTRS:
                    csv.append(txn.get(attr))
                print('^'.join(csv))
                txns.append(csv)
        with open(self.sql, 'w') as out_sql:
            out_sql.write("truncate table cash.ucs_register_tmp;\n")
            out_sql.write(COPY_SQL.format(attrs))
            out_sql.write("""insert into cash.ucs_register (select * from cash.ucs_register_tmp) on conflict do nothing;\n""")
        """
        if txns is not None:
            with open(self.csv, 'w') as out_csv:
                for txn in txns:
                    out_csv.write("%s\n" % txn)
        """

"""
def main():
    "" "Just main" ""
    with open(FNAME) as inpf:
        xml_root = BeautifulSoup(inpf, "lxml")
        #  copy SQL print(','.join(ATTRS))
        print('^'.join(ATTRS))
        for txn in xml_root.find_all('txn'):
            csv = []
            for attr in ATTRS:
                csv.append(txn.get(attr))
            print('^'.join(csv))
"""

if __name__ == "__main__":
    log_app.PARSER.add_argument('--xml', type=str, required=True, help='input xml file')
    ARGS = log_app.PARSER.parse_args()
    APP = UcsApp(args=ARGS)
    APP.prep_import()
    """
    print('Start')
    FNAME = 'rep.xml'
    warnings.filterwarnings('ignore', category=XMLParsedAsHTMLWarning)
    main()
    print('Finish')
    """
