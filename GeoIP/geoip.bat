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
from adjustText import adjust_text
import pygeoip
import matplotlib
# Anti-Grain Geometry (AGG) backend so PyGeoIpMap can be used 'headless'
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap
import webbrowser

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

def get_results(target, out, lats=[], lons=[], labels=[]):
    query = pygeoip.GeoIP('GeoLiteCity.dat')
    asn = pygeoip.GeoIP('GeoIPASNum.dat')
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
#            sys.exit(0)

        if results is not None:
            lats.append(results['latitude'])
            lons.append(results['longitude'])
            labels.append(x+'\n'+str(results['city'])+', '+str(results['country_code']))
    return lats, lons, labels

def generate_map(lons, lats, labels, output):
    m = Basemap(projection='cyl', resolution='l')
    m.drawcountries(linewidth='0.125')
    m.drawstates(linewidth='0.125')
    m.drawcoastlines(linewidth='0.0625')
    m.bluemarble()
    x, y = m(lons, lats)
    m.scatter(x, y, s=0.3, color='#ff0000', marker='.', edgecolors='none', zorder=10)
    texts = []
    for i, txt in enumerate(labels):
       texts.append(plt.text(x[i]+0.1, y[i]+0.1, txt, fontsize=0.1, color='#ff0000', fontweight='bold'))
    adjust_text(texts)
    plt.savefig(output, dpi=900, bbox_inches='tight')
#    mng = plt.get_current_fig_manager()
#    mng.window.state('zoomed')
#    plt.show(output)
    webbrowser.open(output)
    
def main():
#    if os.getenv('PROCDOTPLUGIN_VerificationRun') == '0' or os.getenv('PROCDOTPLUGIN_Name') == 'geoIPgraph':
    out = os.getenv('PROCDOTPLUGIN_ResultTXT')
    output = os.getenv('PROCDOTPLUGIN_GraphFilePng')
    target = get_target(out)
    lats, lons, labels = get_results(target, out)
    generate_map(lons, lats, labels, output)      
#    else:
#        if os.getenv('PROCDOTPLUGIN_CurrentNode_name')[:6] == 'SERVER':
#            sys.exit(1)
#        else:
#            sys.exit(0)
if __name__ == '__main__':
    main()