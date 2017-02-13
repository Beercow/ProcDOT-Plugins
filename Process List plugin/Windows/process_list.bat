@setlocal enabledelayedexpansion && py -x "%~f0" %* & exit /b !ERRORLEVEL!
#!/usr/bin/env python

import os
from itertools import islice

def main():

    data1 = os.getenv('PROCDOTPLUGIN_GraphFileDot')
    data2 = os.getenv('PROCDOTPLUGIN_GraphFileDetails')
    out = os.getenv('PROCDOTPLUGIN_ResultTXT')
    outfile = open(out, 'w')
    IDlist = []
    with open(data1) as f:
        for line in f:
            if line.startswith('  "PROCESS:'):
                line = line.partition('"')[-1].partition('"')[0]
                IDlist.append(line)
    
    ID = list(set(IDlist))
    
    with open(data2) as f:
        for line in f:
            if any(s in line for s in ID):
                test = line + ''.join(islice(f, 13))
                outfile.write(test + '\n')
                
if __name__ == '__main__':
    main()