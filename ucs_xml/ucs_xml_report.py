#!/usr/bin/env python
""" Selenium test """

import os
import time
import logging
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.keys import Keys
import selenium.common.exceptions

import log_app

#USER_LOGIN = 'C3676'
#USER_PASSWORD = '8v7E8iYg'
#TIMEOUT = 5

#UCS_SITE = "https://office.ucscards.ru"
# start=18.11.2022&end=25.11.2022&type=tx&dates=txn_date&page=1&submit=показать"
#URL = "/office/reports/index.php"
#PARAMS = "&type=tx&dates=txn_date&page=1&submit=показать"
#LIST_REPS = "{}/{}".format(UCS_SITE, URL)

#REQ_URL_TEMPL = "{}/{}?show=0&report=1&simple=N&start={}&end={}&{}"
REQ_URL_TEMPL = "{}?show=0&report=1&simple=N&start={}&end={}&{}"
REP_TABLE = u'Потранзакционный отчет за период: {} - {}'

# req = REQ_URL_TEMPL.format(UCS_SITE, URL, start_date, end_date, PARAMS)

class UcsApp(log_app.LogApp):
    """ Main app class """
    def __init__(self, args):
        super(UcsApp, self).__init__(args)
        script_name = os.path.splitext(os.path.basename(__file__))[0]
        self.get_config('{}.conf'.format(script_name))
        self.timeout = float(self.config['UCS']['timeout'])
        if 'base_dir' in self.config['DIRS'].keys():
            self.base_dir = self.config['DIRS']['base_dir']
        else:
            self.base_dir = os.path.dirname(__file__)
        self.xml_dir = '{}/{}'.format(self.base_dir, self.config['DIRS']['xml_dir'])
        self.csv_dir = '{}/{}'.format(self.base_dir, self.config['DIRS']['csv_dir'])
        #self.failed_dir = '{}/{}'.format(self.base_dir, self.config['DIRS']['failed_dir'])
        self.drv = self.create_driver()
        self.base_url = '{}/{}'.format(self.config['UCS']['site'], self.config['UCS']['url'])
        self.req_sent = False

    def create_driver(self):
        """ Create a driver Chrome """
        opts = Options()

        prefs = {"download.default_directory" : self.xml_dir}
        opts.add_experimental_option("prefs", prefs)
        opts.headless = True
        #drv = webdriver.Chrome(options=opts, executable_path=r'C:\path\to\chromedriver.exe')
        drv = webdriver.Chrome(options=opts)
        drv.set_window_size(1920, 1080)
        return drv

    def rep_list(self):
        """ get list of prepared reports """

        logging.info('self.base_url=%s', self.base_url)
        self.drv.get(self.base_url)
        #self.drv.get('{}/{}'.format(self.config['UCS']['site'],
        #                            self.config['UCS']['url']))
        #start_date = '25.11.2022'
        #end_date = '28.11.2022'
        #self.drv.get(REQ_URL_TEMPL.format(UCS_SITE, URL, start_date, end_date, PARAMS))
        logging.info("Headless Chrome Initialized")

        wait = WebDriverWait(self.drv, self.timeout)

        #CLASS cookie-section-wrapper__btn
        wait.until(
            EC.element_to_be_clickable((By.CLASS_NAME, "cookie-section-wrapper__btn"))
        ).click()
        logging.info('cookie OK')

        wait.until(EC.invisibility_of_element((By.CLASS_NAME, "cookie-section")))
        logging.info('cookie invisible')

        form = wait.until(
            EC.element_to_be_clickable((By.NAME, "form_auth"))
            #EC.element_to_be_clickable((By.CLASS_NAME, "btn__in"))
        ) #.click()
        #logging.info('form=%s', form)

        wait.until(
            EC.element_to_be_clickable((By.CLASS_NAME, "bx-auth-input"))
        ).click()
        #self.drv.save_screenshot('screen-auth-click.png')

        login = form.find_element(By.NAME, "USER_LOGIN")
        #logging.info('element login=%s', login)
        #logging.info('login=%s', self.config['UCS']['login'])
        login.send_keys(self.config['UCS']['login'])
        login.send_keys(Keys.TAB)
        #self.drv.save_screenshot('screen-user.png')

        password = form.find_element(By.NAME, "USER_PASSWORD")
        #logging.info('element password=%s', password)
        #logging.info('password=%s', self.config['UCS']['password'])
        password.send_keys(self.config['UCS']['password'])
        password.send_keys(Keys.TAB)
        self.drv.save_screenshot('screen-pass.png')

        enter = form.find_element(By.CLASS_NAME, "btn__in")
        logging.info('enter=%s', enter)
        enter.click()
        self.drv.save_screenshot('screen-enter.png') # save a screenshot to disk

        try:
            element = WebDriverWait(self.drv, self.timeout*2).until(
                EC.presence_of_element_located((By.CLASS_NAME, "add_bordered"))
            )
        except selenium.common.exceptions.TimeoutException:
            if self.req_sent:
                logging.info('req_sent, but report is not ready yet')
            else:
                logging.info('There are not prepared reports')
                self.query_xml()
        else:
            self.parse_table(element)
            #self.drv.save_screenshot('screen-table.png')
            #tds = element.find_elements(By.TAG_NAME, "td")
            #self.download_xml(tds)
            #self.drv.save_screenshot('screen-final.png')
        finally:
            self.drv.quit()

    def parse_table(self, tab_em):
        """ Parse a table of reports """
        self.drv.save_screenshot('screen-table.png')
        tds = tab_em.find_elements(By.TAG_NAME, "td")
        self.download_xml(tds)
        self.drv.save_screenshot('screen-final.png')

    def query_xml(self):
        """ Prepare an xml report """
        loc_req = REQ_URL_TEMPL.format(self.base_url,
                                       req_date(self.args.dt_start),
                                       req_date(self.args.dt_end),
                                       self.config['UCS']['params'])
        logging.info('loc_req=%s', loc_req)
        self.req_sent = True
        self.drv.get(loc_req)

    def download_xml(self, tds):
        """ Downaload a prepared xml report """
        #dt_start = '2022-11-21'
        #dt_end = '2022-11-21'
        flg_period = False
        for tdi in tds:
            if REP_TABLE.format(self.args.dt_start, self.args.dt_end) in tdi.text:
                logging.info('period=%s', tdi.text)
                flg_period = True
            if flg_period and 'xml' in tdi.text:
                logging.info('xml=%s', tdi.text)
                flg_period = False
                #logging.info(tdi.text)
                links = tdi.find_elements(By.TAG_NAME, "a")
                for link in links:
                    # 2022-11-21 - 2022-11-21
                    if 'xml' in link.text:
                        href = link.get_attribute("href")
                        logging.info(href)
                        link.click()
                        time.sleep(5)

def req_date(arg_dt):
    """ Convert date from YYYY-MM-DD to DD.MM.YYYY """
    parts = [arg_dt[8:]]
    parts.append(arg_dt[5:7])
    parts.append(arg_dt[0:4])
    return '.'.join(parts)


if __name__ == '__main__':
    log_app.PARSER.add_argument('--dt_start', type=str, required=True, help='report start date')
    log_app.PARSER.add_argument('--dt_end', type=str, help='report end date')
    ARGS = log_app.PARSER.parse_args()
    if ARGS.dt_end is None:
        ARGS.dt_end = ARGS.dt_start

    APP = UcsApp(args=ARGS)
    #logging.info(req_date(ARGS.dt_start))
    APP.rep_list()

    APP.drv.quit()
