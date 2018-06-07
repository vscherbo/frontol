#-*- coding:utf-8 -*-

import subprocess
rc = subprocess.call(['rsync', '-rltgoDvv', '/var/lib/pgsql/order_photo/', 'order_photo@cifs-public.arc.world:/mnt/r10/ds_cifs/public/order_photos/' ])
print rc

