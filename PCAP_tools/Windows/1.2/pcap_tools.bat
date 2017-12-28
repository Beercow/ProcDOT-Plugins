@setlocal enabledelayedexpansion && py -x "%~f0" %* & exit /b !ERRORLEVEL!
#!/usr/bin/env python
# works with windump version 3.9.5

import os
import sys

if os.getenv('PROCDOTPLUGIN_VerificationRun') == '0' or os.getenv('PROCDOTPLUGIN_Name') == 'Extract Files From PCAP':
    pass
else:
    if os.getenv('PROCDOTPLUGIN_CurrentNode_name')[:6] == 'SERVER':
        sys.exit(1)
    else:
        sys.exit(0)

import csv
import hashlib
import shutil
import subprocess as sub
from httplib import HTTPMessage
import StringIO
import zlib
from Tkinter import *
import tkFileDialog
import base64
import re
from datetime import datetime, timedelta
import time
import itertools
import string
from random import randint, choice

out = os.getenv('PROCDOTPLUGIN_ResultTXT')
temp = os.getenv('PROCDOTPLUGIN_TempFolder')+'\\tcpflow_out\\'


# check for executable files
def ext(header):
    if 'MZ' in header:
        return '.mz'
    return '.bin'


# tcpflow file endings
def extn():
    ending = (('.ez', '.aw', '.atom', '.atomcat', '.atomsvc', '.ccxml', '.cdmia', '.cdmic' '.cdmid', '.cdmio', '.cdmiq', '.cu', '.davmount', '.dssc', '.xdssc', '.ecma' '.emma', '.epub', '.exi', '.pfr', '.stk', '.ipfix', '.jar', '.ser', '.class', '.js' '.json', '.lostxml', '.hqx', '.cpt', '.mads', '.mrc', '.mrcx', '.mb', '.mathml' '.mbox', '.mscml', '.meta4', '.mets', '.mods', '.mp21', '.mp4s', '.doc', '.mxf' '.oda', '.opf', '.ogx', '.onetoc', '.xer', '.pdf', '.pgp', '.asc', '.prf', '.p10' '.p7m', '.p7s', '.p8', '.ac', '.cer', '.crl', '.pkipath', '.pki', '.pls', '.ps' '.cww', '.pskcxml', '.rdf', '.rif', '.rnc', '.rl', '.rld', '.rs', '.rsd', '.rss' '.rtf', '.sbml', '.scq', '.scs', '.spq', '.spp', '.sdp', '.setpay', '.setreg' '.shf', '.smil', '.rq', '.srx', '.gram', '.grxml', '.sru', '.ssml', '.teicorpus' '.tfi', '.tsd', '.plb', '.psb', '.pvb', '.tcap', '.pwn', '.aso', '.imp', '.acu' '.atc', '.air', '.fxp', '.xdp', '.xfdf', '.ahead', '.azf', '.azs', '.azw', '.acc' '.ami', '.apk', '.cii', '.fti', '.atx', '.mpkg', '.m3u8', '.swi', '.aep', '.mpm' '.bmi', '.rep', '.cdxml', '.mmd', '.cdy', '.cla', '.rp9', '.c4g', '.c11amc' '.c11amz', '.csp', '.cdbcmsg', '.cmc', '.clkx', '.clkk', '.clkp', '.clkt', '.clkw' '.wbs', '.pml', '.ppd', '.car', '.pcurl', '.rdz', '.fe_launch', '.dna', '.mlp' '.dpg', '.dfac', '.ait', '.svc', '.geo', '.mag', '.nml', '.esf', '.msf', '.qam' '.slt', '.ssf', '.es3', '.ez2', '.ez3', '.fdf', '.mseed', '.seed', '.gph', '.ftc' '.fm', '.fnc', '.ltf', '.fsc', '.oas', '.oa2', '.oa3', '.fg5', '.bh2', '.ddd' '.xdw', '.xbd', '.fzs', '.txd', '.ggb', '.ggt', '.gex', '.gxt', '.g2w', '.g3w' '.gmx', '.kml', '.kmz', '.gqf', '.gac', '.ghf', '.gim', '.grv', '.gtm', '.tpl' '.vcg', '.hal', '.zmm', '.hbci', '.les', '.hpgl', '.hpid', '.hps', '.jlt', '.pcl' '.pclxl', '.sfd-hdstx', '.x3d', '.mpy', '.afp', '.irm', '.sc', '.icc', '.igl' '.ivp', '.ivu', '.igm', '.xpw', '.i2g', '.qbo', '.qfx', '.rcprofile', '.irp', '.xpr' '.fcs', '.jam', '.rms', '.jisp', '.joda', '.ktz', '.karbon', '.chrt', '.kfo', '.flw' '.kon', '.kpr', '.ksp', '.kwd', '.htke', '.kia', '.knp', '.skp', '.sse', '.lasxml' '.lbd', '.lbe', '.123', '.apr', '.pre', '.nsf', '.org', '.scm', '.lwp', '.portpkg' '.mcd', '.mc1', '.cdkey', '.mwf', '.mfm', '.flo', '.igx', '.mif', '.daf', '.dis' '.mbk', '.mqy', '.msl', '.plc', '.txf', '.mpn', '.mpc', '.xul', '.cil', '.cab' '.xls', '.xlam', '.xlsb', '.xlsm', '.xltm', '.eot', '.chm', '.ims', '.lrm', '.thmx' '.cat', '.stl', '.ppt', '.ppam', '.pptm', '.sldm', '.ppsm', '.potm', '.mpp', '.docm' '.dotm', '.wps', '.wpl', '.xps', '.mseq', '.mus', '.msty', '.nlu', '.nnd', '.nns' '.nnw', '.ngdat', '.n-gage', '.rpst', '.rpss', '.edm', '.edx', '.ext', '.odc' '.otc', '.odb', '.odf', '.odft', '.odg', '.otg', '.odi', '.oti', '.odp', '.otp' '.ods', '.ots', '.odt', '.odm', '.ott', '.oth', '.xo', '.dd2', '.oxt', '.pptx' '.sldx', '.ppsx', '.potx', '.xlsx', '.xltx', '.docx', '.dotx', '.mgp', '.dp', '.pdb' '.paw', '.str', '.ei6', '.efif', '.wg', '.plf', '.pbd', '.box', '.mgz', '.qps' '.ptid', '.qxd', '.bed', '.mxl', '.musicxml', '.cryptonote', '.cod', '.rm' '.link66', '.st', '.see', '.sema', '.semd', '.semf', '.ifm', '.itp', '.iif', '.ipk' '.twd', '.mmf', '.teacher', '.sdkm', '.dxp', '.sfs', '.sdc', '.sda', '.sdd', '.smf' '.sdw', '.sgl', '.sm', '.sxc', '.stc', '.sxd', '.std', '.sxi', '.sti', '.sxm' '.sxw', '.sxg', '.stw', '.sus', '.svd', '.sis', '.xsm', '.bdm', '.xdm', '.tao' '.tmo', '.tpt', '.mxs', '.tra', '.ufdl', '.utz', '.umj', '.unityweb', '.uoml' '.vcx', '.vsd', '.vis', '.vsf', '.wbxml', '.wmlc', '.wmlsc', '.wtb', '.nbp', '.wpd' '.wqd', '.stf', '.xar', '.xfdl', '.hvd', '.hvs', '.hvp', '.osf', '.osfpvg', '.saf' '.spf', '.cmp', '.zir', '.zaz', '.vxml', '.wgt', '.hlp', '.wsdl', '.wspolicy', '.7z' '.abw', '.ace', '.aam', '.aas', '.bcpio', '.torrent', '.bz', '.bz2', '.vcd', '.chat' '.pgn', '.cpio', '.csh', '.deb', '.dir', '.wad', '.ncx', '.dtb', '.res', '.dvi' '.bdf', '.gsf', '.psf', '.otf', '.pcf', '.snf', '.ttf', '.afm', '.woff', '.spl' '.gnumeric', '.gtar', '.hdf', '.jnlp', '.latex', '.mobi', '.m3u8', '.application' '.wmd', '.wmz', '.xbap', '.mdb', '.obd', '.crd', '.clp', '.mvb', '.wmf', '.mny' '.pub', '.scd', '.trm', '.wri', '.nc', '.p12', '.p7b', '.p7r', '.rar', '.sh' '.shar', '.swf', '.xap', '.sit', '.sitx', '.sv4cpio', '.sv4crc', '.tar', '.tcl' '.tex', '.tfm', '.texi', '.ustar', '.src', '.crt', '.fig', '.xpi', '.xdf', '.xenc' '.xhtml', '.xml', '.dtd', '.xop', '.xslt', '.xspf', '.xvml', '.yang', '.yin', '.zip' '.adp', '.au', '.mid', '.mp4a', '.m4a', '.mpga', '.ogg', '.uvva', '.eol', '.dra' '.dts', '.dtshd', '.lvp', '.pya', '.ecelp4800', '.ecelp7470', '.ecelp9600', '.rip' '.weba', '.aac', '.aiff', '.m3u', '.wax', '.wma', '.ram', '.rmp', '.wav', '.cdx' '.cif', '.cmdf', '.cml', '.csml', '.xyz', '.bmp', '.cgm', '.g3', '.gif', '.ief' '.jp2', '.jpg', '.ktx', '.pict', '.png', '.btif', '.svg', '.tiff', '.psd', '.uvi', '.djvu', '.sub', '.dwg', '.dxf', '.fbs', '.fpx', '.fst', '.mmr', '.rlc', '.mdi', '.npx', '.wbmp', '.xif', '.webp', '.ras', '.cmx', '.fh', '.ico', '.pntg', '.pcx', '.pict', '.pnm', '.pbm', '.pgm', '.ppm', '.qtif', '.rgb', '.xbm', '.xpm', '.xwd', '.eml', '.iges', '.mesh', '.dae', '.dwf', '.gdl', '.gtw', '.mts', '.vtu', '.vrml', '.manifest', '.ics', '.css', '.csv', '.html', '.n3', '.txt', '.dsc', '.rtx', '.sgml', '.tsv', '.roff', '.ttl', '.urls', '.curl', '.dcurl', '.mcurl', '.scurl', '.fly', '.flx', '.gv', '.3dml', '.spot', '.jad', '.wml', '.wmls', '.asm', '.c', '.f', '.java', '.pas', '.etx', '.uu', '.vcs', '.vcf', '.3gp', '.3g2', '.h261', '.h263', '.h264', '.jpgv', '.jpm', '.mj2', '.ts', '.m4v', '.mpg', '.ogv', '.mov', '.uvvh', '.uvvm', '.uvvp', '.uvvs', '.uvvv', '.fvt', '.m4u', '.pyv', '.uvvu', '.viv', '.webm', '.dv', '.f4v', '.fli', '.flv', '.m4v', '.asf', '.wm', '.wmv', '.wmx', '.wvx', '.avi', '.movie', '.ice'))
    return ending


# set hash and check value of IP
def check_ip(temp, path, IP, reply):
    folder = str(os.listdir(temp))
    if reply == 'MD5':
        h = hashlib.md5()
    elif reply == 'SHA1':
        h = hashlib.sha1()
    elif reply == 'SHA256':
        h = hashlib.sha256()
    for infile in os.listdir(temp):
        if 'HTTPBODY' in infile:
            if IP is None:
                parse_files(temp, path, h, infile)
            else:
                if IP in folder:
                    if IP in infile:
                        parse_files(temp, path, h, infile)
                else:
                    e = str("No files found.")
                    open(out, 'ab').write(e)


# parse files from pcap
def parse_files(temp, path, h, infile):
    try:
        with open(temp+infile, 'rb') as afile:
            if infile.endswith(extn()):
                end = os.path.splitext(infile)[1]
            else:
                end = ext(afile.read(20))  # if file sig is farther than 20 bytes, change read value
            h.update(afile.read())
            output = h.hexdigest()
            afile.close()
        os.chdir(path)
        shutil.move((temp+infile), (output+end))
    except:
        pass


# parse out tcp flow for IP
def parse_flow(IP, tcpflow):
    styleID = ''.join(choice(string.ascii_lowercase + string.digits) for x in range(randint(8, 12)))
    ssize = len(styleID)
    p = sub.Popen([tcpflow, '-T %T--%A-%B', '-cgB', '-r', (os.getenv('PROCDOTPLUGIN_WindumpFilePcap'))], stdout=sub.PIPE, stderr=sub.PIPE)
    stdout = p.communicate()[0]
    stdout = stdout.replace('\r\n', '\n')
    if IP not in stdout:
        e = str("No tcp flows found for ")+IP
        open(out, 'ab').write(e)
    else:
        if os.getenv('PROCDOTPLUGIN_PluginEngineVersion') is not None:
            open(out, 'ab').write('{{{style-id:default;color:blue;style-id:'+styleID+';color:red}}}')
        m = re.findall('\x1b\[0;31m(.*?)\x1b\[0m|\x1b\[0;34m(.*?)\x1b\[0m', stdout, re.DOTALL)
        m = iter(m)
        for b, r in m:
            if b == '':
                if IP in r:
                    r = r[56:]
                    r = re.sub('[^!\"#\$%&\'\(\)\*\+,-\./0-9:;<=>\?@A-Z\[\]\^_`a-z\{\|\}\\\~\t\n\r ]', '.', r)
                    if os.stat(out).st_size <= 53 + ssize:
                        if os.getenv('PROCDOTPLUGIN_PluginEngineVersion') is not None:
                            open(out, 'ab').write('<'+styleID+'>'+r+'</'+styleID+'>')
                        else:
                            open(out, 'ab').write(r)
                    else:
                        if os.getenv('PROCDOTPLUGIN_PluginEngineVersion') is not None:
                            open(out, 'ab').write('\n\n'+'<'+styleID+'>'+r+'</'+styleID+'>')
                        else:
                            open(out, 'ab').write('\n\n'+r)
            else:
                if IP in b:
                    b = b[56:]
                    match = re.match('^HTTP.*', b)
                    try:
                        if match:
                            length = 1
                            num = 0
                            while length != num:
                                d = zlib.decompressobj(16+zlib.MAX_WBITS)
                                output = StringIO.StringIO(b)
                                status_line = output.readline()
                                msg = HTTPMessage(output, 0)
                                isLength = msg.get('Content-Length')
                                isGZipped = msg.get('content-encoding', '').find('gzip') >= 0
                                isChunked = msg.get('Transfer-Encoding', '').find('chunked') >= 0
                                if isGZipped and isChunked:
                                    length = int(msg.fp.readline(), 16)
                                    encdata = msg.fp.read()[:length]
                                    num = len(encdata)
                                    if length != num:
                                        c = next(m)[0]
                                        if IP in c:
                                            b += c[56:]
                                    else:
                                        data = d.decompress(encdata)
                                elif isGZipped:
                                    length = int(isLength)
                                    body = msg.fp.read()
                                    num = len(body)
                                    if length != num:
                                        c = next(m)[0]
                                        if IP in c:
                                            b += c[56:]
                                    else:
                                        data = d.decompress(body)
                                else:
                                    length = 1
                                    num = 1
                                    data = msg.fp.read()
                            data = re.sub('[^!\"#\$%&\'\(\)\*\+,-\./0-9:;<=>\?@A-Z\[\]\^_`a-z\{\|\}\\\~\t\n\r ]', '.', data)
                            open(out, 'ab').write(status_line)
                            open(out, 'ab').write(str(msg))
                            open(out, 'ab').write('\n')
                            open(out, 'ab').write(data)
                        else:
                            b = re.sub('[^!\"#\$%&\'\(\)\*\+,-\./0-9:;<=>\?@A-Z\[\]\^_`a-z\{\|\}\\\~\t\n\r ]', '.', b)
                            open(out, 'ab').write(b)
                    except:
                        open(out, 'ab').write('DECOMPRESSION ERROR')
                        open(out, 'ab').write('\n\n')
                        b = re.sub('[^!\"#\$%&\'\(\)\*\+,-\./0-9:;<=>\?@A-Z\[\]\^_`a-z\{\|\}\\\~\t\n\r ]', '.', b)
                        open(out, 'ab').write(b)


# Normalizes time
def is_time_format(timeStamp):
    try:
        time.strptime(timeStamp, '%H:%M:%S.%f')
        return True
    except ValueError:
        return False


# get packets for animation mode
def get_packet():
    procdottime = os.getenv('PROCDOTPLUGIN_AnimationMode_CurrentFrame_TimestampOriginalString').replace(',', '.')
    if len(procdottime) == 15:
        procdottime = '0' + procdottime
    with open(os.getenv('PROCDOTPLUGIN_ProcmonFileCsv'), 'rb') as f:
        reader = csv.DictReader(f)
        rows = [row for row in reader if os.getenv('PROCDOTPLUGIN_CurrentNode_Details_IP_Address') in str(row['Path']) and 'TCP' in str(row['Operation'])]
        irofile = iter(rows)
        for row in irofile:
            starttime = str(row['\xef\xbb\xbf"Time of Day"']).replace(',', '.')
            if len(starttime) == 18:
                starttime = '0' + starttime
            if starttime[:16] == procdottime:
                if str(row['Operation']) == 'TCP Receive' or str(row['Operation']) == 'TCP Send':
                    if str(row['Operation']) == 'TCP Send':
                        styleID = '{{{style-id:default;color:red}}}'
                    else:
                        styleID = '{{{style-id:default;color:blue}}}'
                    length = str(row['Detail']).split(',')[0].split(':')[1][1:]
                    if 'PM' in starttime:
                        starttime = starttime[:-4] + ' PM'
                        starttime = datetime.strptime(starttime, '%I:%M:%S.%f %p').strftime('%H:%M:%S.%f')
                    elif 'AM' in starttime:
                        starttime = starttime[:-4] + ' AM'
                        starttime = datetime.strptime(starttime, '%I:%M:%S.%f %p').strftime('%H:%M:%S.%f')
                    else:
                        starttime = datetime.strptime(str(starttime)[:-1], '%H:%M:%S.%f').strftime('%H:%M:%S.%f')
                    row = next(irofile)
                    endtime = str(row['\xef\xbb\xbf"Time of Day"']).replace(',', '.')
                    if len(endtime) == 18:
                        endtime = '0' + endtime
                    if 'PM' in endtime:
                        endtime = endtime[:-4] + ' PM'
                        endtime = datetime.strptime(endtime, '%I:%M:%S.%f %p')
                    elif 'AM' in endtime:
                        endtime = endtime[:-4] + ' AM'
                        endtime = datetime.strptime(endtime, '%I:%M:%S.%f %p')
                    else:
                        endtime = datetime.strptime(str(endtime)[:-1], '%H:%M:%S.%f')
                    endtime = endtime + timedelta(milliseconds=10)
                    endtime = endtime.strftime('%H:%M:%S.%f')
                    execute = os.getenv('PROCDOTPLUGIN_Path2WindumpExecutable') + ' -n -p -A -r ' + '"' + os.getenv('PROCDOTPLUGIN_WindumpFilePcap') + '"' + ' host ' + os.getenv('PROCDOTPLUGIN_CurrentNode_Details_IP_Address')
                    p = sub.Popen(execute, stdout=sub.PIPE, stderr=sub.PIPE)
                    line0, line1 = itertools.tee(p.stdout)
                    try:
                        next(line1)
                    except:
                        e = str("No tcp packets found for ")+os.getenv('PROCDOTPLUGIN_CurrentNode_Details_IP_Address')+(" in this time frame.")
                        open(out, 'wb').write(e)
                        sys.exit(0)
                    lines = zip(line0, line1)
                    lines = iter(lines)
                    for val0, val1 in lines:
                        if '(' + length + ')' in val0:
                            packetstart = datetime.strptime(val0[:15], '%H:%M:%S.%f')
                            offset = str(packetstart)[11:13]
                            offset = int(starttime[:2]) - int(offset)
                            packetstart = packetstart + timedelta(hours=offset)
                            packetstart = packetstart.strftime('%H:%M:%S.%f')
                            if packetstart <= endtime:
                                packet = []
                                while is_time_format(val1[:15]) is False:
                                    packet.append(val1.replace('\r\n', '\n'))
                                    val0, val1 = next(lines)
                                packet = ''.join(packet)
                                open(out, 'wb').write(styleID)
                                open(out, 'ab').write(str(packet)[40:] + '\n')
                elif str(row['Operation']) == 'TCP Connect':
                    open(out, 'ab').write('{{{style-id:default;color:white;background-color:red}}}')
                    open(out, 'ab').write('                           \n')
                    open(out, 'ab').write('                           \n')
                    open(out, 'ab').write('       TCP Connection      \n')
                    open(out, 'ab').write('                           \n')
                    open(out, 'ab').write('                           \n')
                else:
                    open(out, 'ab').write('{{{style-id:default;color:white;background-color:red}}}')
                    open(out, 'ab').write('                           \n')
                    open(out, 'ab').write('                           \n')
                    open(out, 'ab').write('       TCP Disconnect      \n')
                    open(out, 'ab').write('                           \n')
                    open(out, 'ab').write('                           \n')
        if os.stat(out).st_size == 0:
            e = str("No tcp packets found for ")+os.getenv('PROCDOTPLUGIN_CurrentNode_Details_IP_Address')+(" in this time frame.")
            open(out, 'wb').write(e)
            sys.exit(0)


# Filter packets for opening in Wireshark
def filter_pcap():
    name = os.getenv('PROCDOTPLUGIN_TempFolder')+'\\'+os.getenv('PROCDOTPLUGIN_CurrentNode_Details_IP_Address')+'.pcap'
    p = sub.Popen([(os.getenv('PROCDOTPLUGIN_Path2WindumpExecutable')), '-r', (os.getenv('PROCDOTPLUGIN_WindumpFilePcap')), '-w', name, 'host', os.getenv('PROCDOTPLUGIN_CurrentNode_Details_IP_Address')], stdout=sub.PIPE, stderr=sub.PIPE)
    p.wait()
    try:
        try:
            p = sub.Popen([r'C:\Program Files (x86)\Wireshark\Wireshark.exe', name])
        except:
            p = sub.Popen([r'C:\Program Files\Wireshark\Wireshark.exe', name])
    except:
        e = str("Wireshark is missing")
        open(out, 'wb').write(e)
        sys.exit(0)


# Clean up on closing of GUI
def on_closing(root):
    try:
        shutil.rmtree(temp)
    except:
        pass
    root.destroy()
    sys.exit(0)


# GUI for extracting files
def gui(reply, path, tempFile):
    root = Tk()
    reply = StringVar(root)
    reply.set("MD5")  # initial value
    path = StringVar(None)
    path.set("c:/")  # initial value
    root.title("Extract Files")
    root.wm_iconbitmap(tempFile)
    root.resizable(width=FALSE, height=FALSE)

    topFrame = Frame(root)
    topFrame.grid(row=0, column=0)
    middleFrame = Frame(root)
    middleFrame.grid(row=1, column=0)
    bottomFrame = Frame(root)
    bottomFrame.grid(row=2, column=0)
    root.grid_rowconfigure(3, minsize=4)

    Label(topFrame, text="Hash type:").grid(row=0, column=0)
    Radiobutton(topFrame, text="MD5", variable=reply, value="MD5").grid(row=0, column=1)
    Radiobutton(topFrame, text="SHA1", variable=reply, value="SHA1").grid(row=0, column=2)
    Radiobutton(topFrame, text="SHA256", variable=reply, value="SHA256").grid(row=0, column=3)
    Label(middleFrame, text="Save folder:").grid(row=0, column=0)
    Entry(middleFrame, width=25, textvariable=path).grid(row=0, column=1)
    Button(middleFrame, text='...', command=lambda: callback(path)).grid(row=0, column=3, padx=4)
    Button(bottomFrame, text="Extract Files", command=lambda: ok(root)).grid(row=0, column=1)

    root.bind("<Unmap>", lambda e: root.deiconify())
    root.protocol("WM_DELETE_WINDOW", lambda: on_closing(root))
    root.mainloop()

    reply = reply.get()
    path = path.get()
    try:
        if path is not None:
            if not os.path.exists(path):
                os.makedirs(path)
        return reply, path
    except:
        shutil.rmtree(temp)


# get save folder path
def callback(path):
    folder = tkFileDialog.askdirectory(initialdir='C:/', title='Extract files from pcap')
    path.set(folder)


# exit gui
def ok(root):
    root.quit()


# icon for gui
def icon(tempFile):
    icon = \
    """ AAABAAEAECAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AAAAAA4AAAh/AAAVxAAACfIAAAnyAAAVxAAACH8AAAAO////AP///wD///8A////AP///wD///8A////AAAAAEIAAA3pAABx9wAAwP8AAO//AADv/wAAwP8AAHH3AAAN6QAAAEL///8A////AP///wD///8A////AAAAAEIAABfzAADL/wAA//8AAP//AAD//wAA//8AAP//AAD//wAAy/8AABfzAAAAQv///wD///8A////AAAAAA4AAA3pAADL/wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AADL/wAADekAAAAO////AP///wAAAAh/AABx9wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAHH3AAAIf////wD///8AAAAVxAAAwP8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AADA/wAAFcT///8A////AAAACfIAAO//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA7/8AAAny////AP///wAAAAnyAADv/wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAO//AAAJ8v///wD///8AAAAVxAAAwP8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AADA/wAAFcT///8A////AAAACH8AAHH3AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAAcfcAAAh/////AP///wAAAAAOAAAN6QAAy/8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAAy/8AAA3pAAAADv///wD///8A////AAAAAEIAABfzAADL/wAA//8AAP//AAD//wAA//8AAP//AAD//wAAy/8AABfzAAAAQv///wD///8A////AP///wD///8AAAAAQgAADekAAHH3AADA/wAA7/8AAO//AADA/wAAcfcAAA3pAAAAQv///wD///8A////AP///wD///8A////AP///wAAAAAOAAAIfwAAFcQAAAnyAAAJ8gAAFcQAAAh/AAAADv///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A//8AAPw/AADwDwAA4AcAAMADAADAAwAAgAEAAIABAACAAQAAgAEAAMADAADAAwAA4AcAAPAPAAD8PwAA//8AAA==
    """
    icondata = base64.b64decode(icon)
    if not os.path.exists(temp):
        os.makedirs(temp)
    tempFile = temp+"icon.ico"
    iconfile = open(tempFile, "wb")
    iconfile.write(icondata)
    iconfile.close()
    return tempFile


# convert IP into tcpflow format
def parse_IP(IP):
    try:
        one, two, three, four = IP.split('.')
        one = '00'+(one)
        two = '00'+(two)
        three = '00'+(three)
        four = '00'+(four)
        IP = one[-3:]+'.'+two[-3:]+'.'+three[-3:]+'.'+four[-3:]
        return IP
    except:
        e = str("No IP associated with flow.")
        open(out, 'w').write(e)
        sys.exit(0)


# Check for tcpflow
def check_tcpflow_ver(tcpflow):
    try:
        p = sub.Popen([tcpflow, '-V'], stdout=sub.PIPE, stderr=sub.PIPE)
        check = p.communicate()[0]
        if 'tcpflow 1.' not in check.lower() and 'tcpflow 2.' not in check.lower():
            e = str("[ERROR] Please download 1.0 or higer\nDownload: https://github.com/simsong/tcpflow/")
            open(out, 'ab').write(e)
            sys.exit(0)
    except:
        e = str("[ERROR] TCPflow missing. Please download 1.0 or higer.\nDownload: https://github.com/simsong/tcpflow/")
        open(out, 'w').write(e)
        sys.exit(0)


def main():
    reply = None
    path = None
    IP = None
    tempFile = None
    tcpflow = os.getenv('PROCDOTPLUGIN_PluginsPath') + 'tcpflow.exe'

    if os.getenv('PROCDOTPLUGIN_Name') == 'Open Packets in Wireshark':
        filter_pcap()
        sys.exit(0)
    check_tcpflow_ver(tcpflow)
    if os.getenv('PROCDOTPLUGIN_Name') == 'Follow TCP Stream':
        IP = os.getenv('PROCDOTPLUGIN_CurrentNode_Details_IP_Address')
        IP = parse_IP(IP)
        if os.getenv('PROCDOTPLUGIN_AnimationMode') is None or os.getenv('PROCDOTPLUGIN_AnimationMode') == '0':
            parse_flow(IP, tcpflow)
        else:
            get_packet()
    else:
        p = sub.Popen([tcpflow, '-T %N_%A-%B', '-o', (temp), '-ar', (os.getenv('PROCDOTPLUGIN_WindumpFilePcap'))], stdout=sub.PIPE, stderr=sub.PIPE)
        stderr = p.communicate()[1]
        if 'tcpflow' in stderr:
            e = str("PCAP file missing. Please select a PCAP file and try again.")
            open(out, 'ab').write(e)
            sys.exit(0)
        else:
            p.wait()
            tempFile = icon(tempFile)
        reply, path = gui(reply, path, tempFile)
        if os.getenv('PROCDOTPLUGIN_Name') == 'Extract File(s) From Flow':
            IP = os.getenv('PROCDOTPLUGIN_CurrentNode_Details_IP_Address')
            IP = parse_IP(IP)
        check_ip(temp, path, IP, reply)
        shutil.rmtree(temp)


if __name__ == '__main__':
    main()
