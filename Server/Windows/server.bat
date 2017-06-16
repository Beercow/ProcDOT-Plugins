@setlocal enabledelayedexpansion && py -x "%~f0" %* & exit /b !ERRORLEVEL!
import os

def main():

    data = os.getenv('PROCDOTPLUGIN_GraphFileDetails')
    out = os.getenv('PROCDOTPLUGIN_ResultCSV')
    outfile =open(out, 'w')
    domain = None
    ip = None
    onlyinpcap = None
    procmon = None

    outfile.write('"Domain","IP-Address"\n')
    outfile.write('"*","*"\n')

    with open(data) as f:
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
                    if procmon != '':
                        outfile.write('"' +domain + '","' + ip + '"\n')
                    if onlyinpcap == 'Yes':
                        outfile.write('{{color:blue}}' + '"' + domain + '","' + ip + '"\n')
                            
if __name__ == '__main__':
    main()