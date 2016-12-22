@setlocal enabledelayedexpansion && python -x "%~f0" %* & exit /b !ERRORLEVEL!
#!/usr/bin/env python

import os
import sys
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

out = os.getenv('PROCDOTPLUGIN_ResultTXT')
temp = os.getenv('LOCALAPPDATA')+'\\temp\\tcpflow_out\\'

#check for executable files
def ext(header):
    if 'MZ' in header:
        return '.mz'
    else:
        return '.bin'

#tcpflow file endings
def extn():
    ending = (('.ez', '.aw', '.atom', '.atomcat', '.atomsvc', '.ccxml', '.cdmia', '.cdmic', '.cdmid', '.cdmio', '.cdmiq', '.cu', '.davmount', '.dssc', '.xdssc', '.ecma', '.emma', '.epub', '.exi', '.pfr', '.stk', '.ipfix', '.jar', '.ser', '.class', '.js', '.json', '.lostxml', '.hqx', '.cpt', '.mads', '.mrc', '.mrcx', '.mb', '.mathml', '.mbox', '.mscml', '.meta4', '.mets', '.mods', '.mp21', '.mp4s', '.doc', '.mxf', '.oda', '.opf', '.ogx', '.onetoc', '.xer', '.pdf', '.pgp', '.asc', '.prf', '.p10', '.p7m', '.p7s', '.p8', '.ac', '.cer', '.crl', '.pkipath', '.pki', '.pls', '.ps', '.cww', '.pskcxml', '.rdf', '.rif', '.rnc', '.rl', '.rld', '.rs', '.rsd', '.rss', '.rtf', '.sbml', '.scq', '.scs', '.spq', '.spp', '.sdp', '.setpay', '.setreg', '.shf', '.smil', '.rq', '.srx', '.gram', '.grxml', '.sru', '.ssml', '.teicorpus', '.tfi', '.tsd', '.plb', '.psb', '.pvb', '.tcap', '.pwn', '.aso', '.imp', '.acu', '.atc', '.air', '.fxp', '.xdp', '.xfdf', '.ahead', '.azf', '.azs', '.azw', '.acc', '.ami', '.apk', '.cii', '.fti', '.atx', '.mpkg', '.m3u8', '.swi', '.aep', '.mpm', '.bmi', '.rep', '.cdxml', '.mmd', '.cdy', '.cla', '.rp9', '.c4g', '.c11amc', '.c11amz', '.csp', '.cdbcmsg', '.cmc', '.clkx', '.clkk', '.clkp', '.clkt', '.clkw', '.wbs', '.pml', '.ppd', '.car', '.pcurl', '.rdz', '.fe_launch', '.dna', '.mlp', '.dpg', '.dfac', '.ait', '.svc', '.geo', '.mag', '.nml', '.esf', '.msf', '.qam', '.slt', '.ssf', '.es3', '.ez2', '.ez3', '.fdf', '.mseed', '.seed', '.gph', '.ftc', '.fm', '.fnc', '.ltf', '.fsc', '.oas', '.oa2', '.oa3', '.fg5', '.bh2', '.ddd', '.xdw', '.xbd', '.fzs', '.txd', '.ggb', '.ggt', '.gex', '.gxt', '.g2w', '.g3w', '.gmx', '.kml', '.kmz', '.gqf', '.gac', '.ghf', '.gim', '.grv', '.gtm', '.tpl', '.vcg', '.hal', '.zmm', '.hbci', '.les', '.hpgl', '.hpid', '.hps', '.jlt', '.pcl', '.pclxl', '.sfd-hdstx', '.x3d', '.mpy', '.afp', '.irm', '.sc', '.icc', '.igl', '.ivp', '.ivu', '.igm', '.xpw', '.i2g', '.qbo', '.qfx', '.rcprofile', '.irp', '.xpr', '.fcs', '.jam', '.rms', '.jisp', '.joda', '.ktz', '.karbon', '.chrt', '.kfo', '.flw', '.kon', '.kpr', '.ksp', '.kwd', '.htke', '.kia', '.knp', '.skp', '.sse', '.lasxml', '.lbd', '.lbe', '.123', '.apr', '.pre', '.nsf', '.org', '.scm', '.lwp', '.portpkg', '.mcd', '.mc1', '.cdkey', '.mwf', '.mfm', '.flo', '.igx', '.mif', '.daf', '.dis', '.mbk', '.mqy', '.msl', '.plc', '.txf', '.mpn', '.mpc', '.xul', '.cil', '.cab', '.xls', '.xlam', '.xlsb', '.xlsm', '.xltm', '.eot', '.chm', '.ims', '.lrm', '.thmx', '.cat', '.stl', '.ppt', '.ppam', '.pptm', '.sldm', '.ppsm', '.potm', '.mpp', '.docm', '.dotm', '.wps', '.wpl', '.xps', '.mseq', '.mus', '.msty', '.nlu', '.nnd', '.nns', '.nnw', '.ngdat', '.n-gage', '.rpst', '.rpss', '.edm', '.edx', '.ext', '.odc', '.otc', '.odb', '.odf', '.odft', '.odg', '.otg', '.odi', '.oti', '.odp', '.otp', '.ods', '.ots', '.odt', '.odm', '.ott', '.oth', '.xo', '.dd2', '.oxt', '.pptx', '.sldx', '.ppsx', '.potx', '.xlsx', '.xltx', '.docx', '.dotx', '.mgp', '.dp', '.pdb', '.paw', '.str', '.ei6', '.efif', '.wg', '.plf', '.pbd', '.box', '.mgz', '.qps', '.ptid', '.qxd', '.bed', '.mxl', '.musicxml', '.cryptonote', '.cod', '.rm', '.link66', '.st', '.see', '.sema', '.semd', '.semf', '.ifm', '.itp', '.iif', '.ipk', '.twd', '.mmf', '.teacher', '.sdkm', '.dxp', '.sfs', '.sdc', '.sda', '.sdd', '.smf', '.sdw', '.sgl', '.sm', '.sxc', '.stc', '.sxd', '.std', '.sxi', '.sti', '.sxm', '.sxw', '.sxg', '.stw', '.sus', '.svd', '.sis', '.xsm', '.bdm', '.xdm', '.tao', '.tmo', '.tpt', '.mxs', '.tra', '.ufdl', '.utz', '.umj', '.unityweb', '.uoml', '.vcx', '.vsd', '.vis', '.vsf', '.wbxml', '.wmlc', '.wmlsc', '.wtb', '.nbp', '.wpd', '.wqd', '.stf', '.xar', '.xfdl', '.hvd', '.hvs', '.hvp', '.osf', '.osfpvg', '.saf', '.spf', '.cmp', '.zir', '.zaz', '.vxml', '.wgt', '.hlp', '.wsdl', '.wspolicy', '.7z', '.abw', '.ace', '.aam', '.aas', '.bcpio', '.torrent', '.bz', '.bz2', '.vcd', '.chat', '.pgn', '.cpio', '.csh', '.deb', '.dir', '.wad', '.ncx', '.dtb', '.res', '.dvi', '.bdf', '.gsf', '.psf', '.otf', '.pcf', '.snf', '.ttf', '.afm', '.woff', '.spl', '.gnumeric', '.gtar', '.hdf', '.jnlp', '.latex', '.mobi', '.m3u8', '.application', '.wmd', '.wmz', '.xbap', '.mdb', '.obd', '.crd', '.clp', '.mvb', '.wmf', '.mny', '.pub', '.scd', '.trm', '.wri', '.nc', '.p12', '.p7b', '.p7r', '.rar', '.sh', '.shar', '.swf', '.xap', '.sit', '.sitx', '.sv4cpio', '.sv4crc', '.tar', '.tcl', '.tex', '.tfm', '.texi', '.ustar', '.src', '.crt', '.fig', '.xpi', '.xdf', '.xenc', '.xhtml', '.xml', '.dtd', '.xop', '.xslt', '.xspf', '.xvml', '.yang', '.yin', '.zip', '.adp', '.au', '.mid', '.mp4a', '.m4a', '.mpga', '.ogg', '.uvva', '.eol', '.dra', '.dts', '.dtshd', '.lvp', '.pya', '.ecelp4800', '.ecelp7470', '.ecelp9600', '.rip', '.weba', '.aac', '.aiff', '.m3u', '.wax', '.wma', '.ram', '.rmp', '.wav', '.cdx', '.cif', '.cmdf', '.cml', '.csml', '.xyz', '.bmp', '.cgm', '.g3', '.gif', '.ief', '.jp2', '.jpg', '.ktx', '.pict', '.png', '.btif', '.svg', '.tiff', '.psd', '.uvi', '.djvu', '.sub', '.dwg', '.dxf', '.fbs', '.fpx', '.fst', '.mmr', '.rlc', '.mdi', '.npx', '.wbmp', '.xif', '.webp', '.ras', '.cmx', '.fh', '.ico', '.pntg', '.pcx', '.pict', '.pnm', '.pbm', '.pgm', '.ppm', '.qtif', '.rgb', '.xbm', '.xpm', '.xwd', '.eml', '.iges', '.mesh', '.dae', '.dwf', '.gdl', '.gtw', '.mts', '.vtu', '.vrml', '.manifest', '.ics', '.css', '.csv', '.html', '.n3', '.txt', '.dsc', '.rtx', '.sgml', '.tsv', '.roff', '.ttl', '.urls', '.curl', '.dcurl', '.mcurl', '.scurl', '.fly', '.flx', '.gv', '.3dml', '.spot', '.jad', '.wml', '.wmls', '.asm', '.c', '.f', '.java', '.pas', '.etx', '.uu', '.vcs', '.vcf', '.3gp', '.3g2', '.h261', '.h263', '.h264', '.jpgv', '.jpm', '.mj2', '.ts', '.m4v', '.mpg', '.ogv', '.mov', '.uvvh', '.uvvm', '.uvvp', '.uvvs', '.uvvv', '.fvt', '.m4u', '.pyv', '.uvvu', '.viv', '.webm', '.dv', '.f4v', '.fli', '.flv', '.m4v', '.asf', '.wm', '.wmv', '.wmx', '.wvx', '.avi', '.movie', '.ice'))
    return ending

def parse_files(temp,path,IP,reply):
    #parse all files from pcap
    if reply == 'MD5':
        h = hashlib.md5()
    elif reply == 'SHA1':
        h = hashlib.sha1()
    elif reply == 'SHA256':
        h = hashlib.sha256()
    if IP == None:
        for infile in os.listdir(temp):
            if 'HTTPBODY' in infile:
                if infile.endswith(extn()):
                    with open (temp+infile, 'rb') as afile:
                        buf = afile.read()
                        h.update(buf)
                        output = h.hexdigest()
                        afile.close()
                    filename, fileExtention = os.path.splitext(infile)
                    os.chdir(path)
                    shutil.move((temp+infile),(output+fileExtention))
                else:
                    try:
                        with open(temp+infile, 'rb') as afile:
                            end = ext(afile.read(20))
                            buf = afile.read()
                            h.update(buf)
                            output = h.hexdigest()
                            afile.close()
                        filename, fileExtention = os.path.splitext(infile)
                        os.chdir(path)
                        shutil.move((temp+infile),(output+end))
                    except:
                        pass
    #parse files for tcp flow
    else:
        folder = str(os.listdir(temp))
        if IP in folder:
            for infile in os.listdir(temp):
                if 'HTTPBODY' in infile:
                    if IP in infile:
                        if infile.endswith(extn()):
                            with open (temp+infile, 'rb') as afile:
                                buf = afile.read()
                                h.update(buf)
                                output = h.hexdigest()
                                afile.close()
                            filename, fileExtention = os.path.splitext(infile)
                            os.chdir(path)
                            shutil.move((temp+infile),(output+fileExtention))
                        else:
                            try:
                                with open(temp+infile, 'rb') as afile:
                                    end = ext(afile.read(20))
                                    buf = afile.read()
                                    h.update(buf)
                                    output = h.hexdigest()
                                    afile.close()
                                filename, fileExtention = os.path.splitext(infile)
                                os.chdir(path)
                                shutil.move((temp+infile),(output+end))
                            except:
                                pass
        else:
            e = str("No files found.")
            open(out,'ab').write(e)

#parse out tcp flow for IP
def parse_flow(IP):
    p = sub.Popen(['tcpflow', '-T %T--%A-%B', '-cgB', '-r', (os.getenv('PROCDOTPLUGIN_WindumpFilePcap'))], stdout=sub.PIPE, stderr=sub.PIPE)
    stdout, stderr = p.communicate()
    stdout = stdout.replace('\r\n', '\n')

    if IP not in stdout:
        e = str("No tcp flows found for ")+IP
        open(out, 'ab').write(e)
    
    else:
        m = re.findall ( '\x1b\[0;3[1|4]m(.*?)\x1b\[0m', stdout, re.DOTALL)
        m = iter(m)    
        for line in m:
            if IP in line:
                line = line[56:]
                match = re.match( '^HTTP.*', line)
                try:
                    if match:
                        length = 1
                        num = 0
                        while length != num:
                            d = zlib.decompressobj(16+zlib.MAX_WBITS)
                            output = StringIO.StringIO(line)
                            status_line = output.readline()
                            msg = HTTPMessage(output, 0)
                            isGZipped = msg.get('content-encoding', '').find('gzip') >= 0
                            isChunked = msg.get('Transfer-Encoding', '').find('chunked') >= 0
                            if isGZipped and isChunked:
                                offset = msg.fp.readline()
                                body = msg.fp.read()
                                num = int(offset, 16)
                                encdata = ''
                                newdata = ''
                                encdata =body[:num]
                                length = len(encdata)
                                if length != num:
                                    line = line + next(m)[56:]
                                else:    
                                    newdata = d.decompress(encdata)
                                    header = str(msg)
                                    open(out,'ab').write(status_line)
                                    open(out,'ab').write(header)
                                    open(out,'ab').write('\n')
                                    open(out,'ab').write(newdata)
                            elif isGZipped:
                                length = 1
                                num = 1
                                body = msg.fp.read()
                                data = d.decompress(body)
                                header = str(msg)
                                open(out,'ab').write(status_line)
                                open(out,'ab').write(header)
                                open(out,'ab').write('\n')
                                open(out,'ab').write(data)
                            else:
                                length = 1
                                num = 1
                                body = msg.fp.read()
                                body = re.sub( '[^!\"#\$%&\'\(\)\*\+,-\./0-9:;<=>\?@A-Z\[\]\^_`a-z\{\|\}\\\~\t\n\r ]','.', body)
                                header = str(msg)
                                open(out,'ab').write(status_line)
                                open(out,'ab').write(header)
                                open(out,'ab').write('\n')
                                open(out,'ab').write(body)
                    else:
                        line = re.sub( '[^!\"#\$%&\'\(\)\*\+,-\./0-9:;<=>\?@A-Z\[\]\^_`a-z\{\|\}\\\~\t\n\r ]','.', line)
                        open(out,'ab').write(line)
                except:
                    open(out,'ab').write('DECOMPRESSION ERROR')
                    open(out,'ab').write('\n\n')
                    open(out,'ab').write(line)

def on_closing(root):
    shutil.rmtree(temp)
    root.destroy()
    
def gui(reply,path,tempFile):
    root = Tk()
    reply = StringVar(root)
    reply.set("MD5") # initial value
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
    Button(middleFrame, text='...', command=lambda:callback(path)).grid(row=0, column=3, padx=4)
    Button(bottomFrame, text="Extract Files", command=lambda:ok(reply, path, root)).grid(row=0, column=1)

    root.bind("<Unmap>", lambda e: root.deiconify())
    root.protocol("WM_DELETE_WINDOW", lambda:on_closing(root))
    root.mainloop()
    
    reply = reply.get()
    path = path.get()
    try:
        if path != None:
            if not os.path.exists(path):
                os.makedirs(path)
                return reply,path
            else:
                return reply,path
    except:
        shutil.rmtree(temp)
#get save folder path
def callback(path):
    folder = tkFileDialog.askdirectory(initialdir='C:/', title='Extract files from pcap') 
    path.set(folder)

#exit gui
def ok(reply, path, root):
    root.quit()

#icon for gui
def icon(tempFile):
    icon = \
    """ AAABAAEAECAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AAAAAA4AAAh/AAAVxAAACfIAAAnyAAAVxAAACH8AAAAO////AP///wD///8A////AP///wD///8A////AAAAAEIAAA3pAABx9wAAwP8AAO//AADv/wAAwP8AAHH3AAAN6QAAAEL///8A////AP///wD///8A////AAAAAEIAABfzAADL/wAA//8AAP//AAD//wAA//8AAP//AAD//wAAy/8AABfzAAAAQv///wD///8A////AAAAAA4AAA3pAADL/wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AADL/wAADekAAAAO////AP///wAAAAh/AABx9wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAHH3AAAIf////wD///8AAAAVxAAAwP8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AADA/wAAFcT///8A////AAAACfIAAO//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA7/8AAAny////AP///wAAAAnyAADv/wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAO//AAAJ8v///wD///8AAAAVxAAAwP8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AADA/wAAFcT///8A////AAAACH8AAHH3AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAAcfcAAAh/////AP///wAAAAAOAAAN6QAAy/8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAAy/8AAA3pAAAADv///wD///8A////AAAAAEIAABfzAADL/wAA//8AAP//AAD//wAA//8AAP//AAD//wAAy/8AABfzAAAAQv///wD///8A////AP///wD///8AAAAAQgAADekAAHH3AADA/wAA7/8AAO//AADA/wAAcfcAAA3pAAAAQv///wD///8A////AP///wD///8A////AP///wAAAAAOAAAIfwAAFcQAAAnyAAAJ8gAAFcQAAAh/AAAADv///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A//8AAPw/AADwDwAA4AcAAMADAADAAwAAgAEAAIABAACAAQAAgAEAAMADAADAAwAA4AcAAPAPAAD8PwAA//8AAA==
    """
    icondata= base64.b64decode(icon)
    tempFile= temp+"icon.ico"
    iconfile= open(tempFile,"wb")
    iconfile.write(icondata)
    iconfile.close()
    return tempFile
    
#convert IP into tcpflow format
def parse_IP(IP):
    try:
        one, two, three, four = IP.split('.')
        one='00'+(one)
        two='00'+(two)
        three='00'+(three)
        four='00'+(four)
        IP=one[-3:]+'.'+two[-3:]+'.'+three[-3:]+'.'+four[-3:]
        return IP
    except:
        e = str("No IP associated with flow.")
        open(out,'w').write(e)
        sys.exit(0)

def check_tcpflow_ver():
    try:
        p = sub.Popen(['tcpflow', '-V'], stdout=sub.PIPE, stderr=sub.PIPE)
        check = p.communicate()[0] 
        if 'tcpflow 1.' not in check.lower() and 'tcpflow 2.' not in check.lower():
            e = str("[ERROR] Please download 1.0 or higer\nDownload: https://github.com/simsong/tcpflow/")
            open(out,'ab').write(e)
            sys.exit(0)
    except:
        e = str("[ERROR] TCPflow missing. Please download 1.0 or higer.\nDownload: https://github.com/simsong/tcpflow/")
        open(out,'w').write(e)
        sys.exit(0) 
 
def main():
    reply = None
    path = None
    IP = None
    tempFile = None

    if os.getenv('PROCDOTPLUGIN_VerificationRun') == '0' or os.getenv('PROCDOTPLUGIN_Name') == 'Extract Files From PCAP':
        check_tcpflow_ver()
        if os.getenv('PROCDOTPLUGIN_Name') == 'Extract Files From PCAP':
            p = sub.Popen(['tcpflow', '-T %N_%A-%B', '-o', (temp), '-ar', (os.getenv('PROCDOTPLUGIN_WindumpFilePcap'))], stdout=sub.PIPE, stderr=sub.PIPE)
            stdout, stderr = p.communicate()
            if 'tcpflow:' in stderr:
                e = str("PCAP file missing. Please select a PCAP file and try again.")
                open(out,'ab').write(e)
                sys.exit(0)
            else:
                p.wait()
                tempFile = icon(tempFile)
            reply,path = gui(reply,path,tempFile)
            parse_files(temp,path,IP,reply)
            shutil.rmtree(temp)
        elif os.getenv('PROCDOTPLUGIN_Name') == 'Follow TCP Stream':
            IP = os.getenv('PROCDOTPLUGIN_CurrentNode_Details_IP_Address')
            IP = parse_IP(IP)
            parse_flow(IP)
        else:
            p = sub.Popen(['tcpflow', '-T %N_%A-%B', '-o', (temp), '-ar', (os.getenv('PROCDOTPLUGIN_WindumpFilePcap'))], stdout=sub.PIPE, stderr=sub.PIPE)
            p.wait()
            tempFile = icon(tempFile)
            reply,path = gui(reply,path,tempFile)
            IP = os.getenv('PROCDOTPLUGIN_CurrentNode_Details_IP_Address')
            IP = parse_IP(IP)
            parse_files(temp,path,IP,reply)
            shutil.rmtree(temp)
    else:
        if os.getenv('PROCDOTPLUGIN_CurrentNode_name')[:6] == 'SERVER':
            sys.exit(1)
        else:
            sys.exit(0)
            
if __name__ == '__main__':
    main()
