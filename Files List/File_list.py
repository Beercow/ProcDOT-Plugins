#!/usr/bin/env python

import os

def main():
    
    data = os.getenv('PROCDOTPLUGIN_GraphFileDot')
    out = os.getenv('PROCDOTPLUGIN_ResultCSV')
    outfile = open(out, 'w')
    outfile.write ('"File Path","Exists"\n')
    outfile.write ('"*","*"\n')
    with open(data) as f:
        for line in f:
            if line.startswith('  "FILE:'):
                if 'fontcolor = magenta' in line:
                    line = line.strip().split('"')
                    f1 = (','.join(line[1:2]))
                    f2 = (','.join(line[3:4]))
                    outfile.write('{{color:purple}}' + '"' + f1[5:] + ' -> ' + f2[5:] + '","rename"\n')
                elif 'fontcolor = red' in line:
                    line = line.strip().split('"')
                    line = (','.join(line[1:2]))
                    outfile.write('{{color:red}}' + '"' + line[5:] + '","No"\n')  
                else:
                    line = line.strip().split('"')
                    line = (','.join(line[1:2]))
                    outfile.write('"' + line[5:] + '","Yes"\n')
        
if __name__ == '__main__':
    main()
