#!/usr/bin/env python

import os
from itertools import islice
import csv

def main():

    data1 = os.getenv('PROCDOTPLUGIN_GraphFileDot')
    data2 = os.getenv('PROCDOTPLUGIN_GraphFileDetails')
    data3 = os.getenv('PROCDOTPLUGIN_ProcmonFile')
    out = os.getenv('PROCDOTPLUGIN_ResultTXT')
    outfile = open(out, 'w')
    IDlist = []
    with open(data1) as f:
        for line in f:
            if line.startswith('  "REGISTRYKEY:'):
                line = line.partition('"')[-1].partition('"')[0]
                IDlist.append(line)
    
    ID = list(set(IDlist))
    
    with open(data2) as f, open(data3, 'rb') as c:
        reader = csv.reader(c)
        for line in f:
            if any(s in line for s in ID):
                test = line + ''.join(islice(f, 12))
                csvLine = test.rsplit('= ', 1)[1]
                c.seek(0)
                csvInfo = [next(islice(reader, (int(csvLine) - 1), None))[6]]
                csvInfo = [w.replace(':', ' =', 3).replace(', ', '\n', 2) for w in csvInfo]
                outfile.write(test + '\n'.join(csvInfo) + '\n\n')

if __name__ == '__main__':
    main()