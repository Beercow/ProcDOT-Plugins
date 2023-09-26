#!/usr/bin/env python

import os
import pygeoip
import sys
import urllib
import gzip

reload(sys)
sys.setdefaultencoding('utf8')
out = os.getenv('PROCDOTPLUGIN_ResultTXT')

def database(url,dbgz,db):
    geo = urllib.URLopener()
    try:
        geo.retrieve(url, dbgz)
        with gzip.open(dbgz, 'rb') as infile:
            with open(db, 'wb') as outfile:
                for line in infile:
                    outfile.write(line)
        os.remove(dbgz)
    except Exception as e:
        open(out, 'wb').write(str(e))
        sys.exit(0)

if os.path.isfile('GeoLiteCity.dat'):
    pass
else:
    database('https://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz', 'GeoLiteCity.dat.gz', 'GeoLiteCity.dat')

if os.path.isfile('GeoIPASNum.dat'):
    pass
else:
    database('https://download.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz', 'GeoIPASNum.dat.gz', 'GeoIPASNum.dat')
       
tfolder =  os.listdir(os.getenv('PROCDOTPLUGIN_TempFolder'))
details = open(os.getenv('PROCDOTPLUGIN_GraphFileDetails'),'rb').readlines()
n = open(os.getenv('PROCDOTPLUGIN_GraphFileDetails'),'w')

for num, line in enumerate(details,1):
    if 'IP-Address' in line:
        query = pygeoip.GeoIP('GeoLiteCity.dat')
        asn = pygeoip.GeoIP('GeoIPASNum.dat')
        x = [x.strip() for x in line.split(' ')][2]
        try:
            results = query.record_by_addr(x)
            asn_info = asn.asn_by_addr(x)
            for key, val in results.items():
                details.insert(num,str(key) + ' = ' + str(val) + '\n')

            try:
                details.insert(num,'asn = '+asn_info+'\n')
            except:
                pass
        except:
            pass
details = "".join(details)
n.write(details)
n.close()
sys.exit(0)
