@setlocal enabledelayedexpansion && py -x "%~f0" %* & exit /b !ERRORLEVEL!
#!/usr/bin/env python

import os
import sys
if os.getenv('PROCDOTPLUGIN_VerificationRun') == '0' or os.getenv('PROCDOTPLUGIN_Name') == 'geoIPgraph':
    pass
else:
    if os.getenv('PROCDOTPLUGIN_CurrentNode_name')[:6] == 'SERVER':
        sys.exit(1)
    else:
        sys.exit(0)
from itertools import islice
import pygeoip

def get_target(out):
    if os.getenv('PROCDOTPLUGIN_Name') == 'geoIP': 
        ips = [os.getenv('PROCDOTPLUGIN_CurrentNode_Details_IP_Address')]
    else:
        data2 = os.getenv('PROCDOTPLUGIN_GraphFileDetails')
        domain = None
        ips = []
        ip = None
        onlyinpcap = None
        prcomon = None
        if os.path.isfile(os.getenv('PROCDOTPLUGIN_GraphFileDetails')):
            with open(data2) as f:
                for line in f:
                    c = line.split(' ', 2)
                    if c[0] == 'Domain':
                        domain = ''.join(c[2:]).strip()
                    if c[0] =='IP-Address':
                        ip = ''.join(c[2:]).strip()
                    if c[0] == 'OnlyInPCAP':
                        onlyinpcap = ''.join(c[2:]).strip()
                    if c[0] == 'RelevantBecauseOfProcmonLines':
                        procmon = ''.join(c[2:]).strip()
                        if domain != ip:
                            if onlyinpcap == 'No':
                                if procmon != '':
                                    ips.append(ip)
        else:
            e = str('Error. Please refresh graph.')
            open(out,'w').write(e)
            sys.exit(0)
    return ips

def get_results(target, out, outcsv, lats=[], lons=[], labels=[]):
    query = pygeoip.GeoIP('GeoLiteCity.dat')
    asn = pygeoip.GeoIP('GeoIPASNum.dat')
    if os.getenv('PROCDOTPLUGIN_Name') == 'geoIP':
        for x in target:
            try:
                results = query.record_by_addr(x)
                asn_info = asn.asn_by_addr(x)
                with open(out, 'ab') as file:
                    file.write('[*] Query Results: \n\n')
                    file.write('\tIP: '+x+'\n')
                    for key, val in results.items():
                        file.write('\t'+str(key) + ': ' + str(val) + '\n')
                    try:
                        file.write('\tasn: '+asn_info+'\n')
                    except:
                        file.write('\tasn: No information\n')
                    file.write('\n[*] End of Results\n\n')
            except:
                e = '\t'+str("No information on:")+x+'\n\n[*] End of Results\n\n'
                open(out,'ab').write(e)

    else:
        with open(outcsv, 'ab') as file:
            file.write('"IP","City","Region Code","Area Code","Time Zone","DMA Code","Metro Code","Country Code","Latitude","Postal Code","Longitude","Country Code","Country Name","Continent","ASN"\n')
            file.write('"*","*","*","*","*","*","*","*","*","*","*","*","*","*","*"\n')
            for x in target:
                try:
                    results = query.record_by_addr(x)
                    asn_info = asn.asn_by_addr(x)
                    file.write('"' + x + '","')
                    for key, val in results.items():
                        file.write('"' + str(val) + '","')
                    try:
                        file.write(asn_info + '"\n')
                    except:
                        file.write('N\\A"\n')
                except:
                    file.write('"' + x + '"\n')
    
def main():
    out = os.getenv('PROCDOTPLUGIN_ResultTXT')
    outcsv = os.getenv('PROCDOTPLUGIN_ResultCSV')
    output = os.getenv('PROCDOTPLUGIN_GraphFilePng')
    target = get_target(out)
    get_results(target, out, outcsv)

if __name__ == '__main__':
    main()
