-- DROP FUNCTION cash.sftp_text(text, text, integer, text[]);

CREATE OR REPLACE FUNCTION cash.sftp_text(
IN rem_user text,
IN rem_host text,
IN rem_port integer,
IN rem_file text,
IN arg_list text[])
 RETURNS boolean
AS $function$
import logging
from os.path import expanduser
home_dir = expanduser("~")
log_dir = home_dir + '/logs/'
log_format = '%(levelname)-7s | %(asctime)-15s | %(message)s'
formatter = logging.Formatter(log_format)

logger = logging.getLogger("sftp_text")
if not len(logger.handlers):
    file_handler = logging.FileHandler(log_dir+'exec_paramiko.log')
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)
    logger.setLevel(logging.DEBUG)

logging.getLogger("sftp_text").setLevel(logging.INFO)

# ptr_ means paramiko.transport

ptr_logger = logging.getLogger("paramiko.transport")
if not len(ptr_logger.handlers):
    file_handler = logging.FileHandler(log_dir+'exec_paramiko.transport.log')
    file_handler.setFormatter(formatter)
    ptr_logger.addHandler(file_handler)
    ptr_logger.setLevel(logging.WARNING)

import paramiko
from datetime import datetime

out_res = False
logger.debug("Start")

k = paramiko.RSAKey.from_private_key_file(home_dir + "/.ssh/id_rsa")
client = paramiko.SSHClient()
client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
try:
    out_str = ''
    err_str = ''
    client.connect(hostname=rem_host, username=rem_user, pkey=k, port=rem_port)
except Exception:
    logger.exception("client.connect exception")
else:
    try:
        logger.info("client connected")
        ftp = client.open_sftp()
        file=ftp.file(rem_file, "w", -1)
        logger.info("file created")
        file.writelines(arg_list)
        file.flush()
        logger.info("file flushed")
        ftp.close()
        logger.info("ftp closed")
    except Exception:
        logger.exception("sftp exception")
    else:
        logger.info("sftp write completed")
        out_res = True

logger.debug("Finish")
logger.info('================================')
client.close()
return out_res
$function$
  LANGUAGE plpython2u VOLATILE
