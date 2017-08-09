#!/usr/bin/env python

import os
from itertools import islice

def main():

    data1 = os.getenv('PROCDOTPLUGIN_GraphFileDot')
    data2 = os.getenv('PROCDOTPLUGIN_GraphFileDetails')
    out = os.getenv('PROCDOTPLUGIN_ResultCSV')
    outfile = open(out, 'w')
    outfile.write('"PID","Name","Path","Full Path","Command Line","Start Time","ParentPID","ParentTID","Stop Time","Stopped by PID","Stopped by TID","Relevant Because of Procmon Lines","Threads"\n')
    outfile.write('"*","*","*","*","*","*","*","*","*","*","*","*","*"\n')
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
                test=[]
                test.append(''.join(islice(f, 13)))
                for element in test:
                    part =  element.split('\n')
                outfile.write('"'+part[0][5:].split('-')[0]+'","'+part[1][7:]+'","'+part[2][7:-1]+'","'+part[3][11:]+'","'+part[4][14:]+'","'+part[5][12:]+'","'+part[6][12:].split('-')[0]+'","'+part[7][12:].split('-')[0]+'","'+part[8][12:]+'","'+part[9][15:].split('-')[0]+'","'+part[10][15:].split('-')[0]+'","'+part[11][32:]+'","'+part[12][10:]+'"\n')
                
if __name__ == '__main__':
    main()
