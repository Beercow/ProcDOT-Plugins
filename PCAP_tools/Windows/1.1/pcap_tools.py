#!/usr/bin/env python

import os
import hashlib
import shutil
import subprocess as sub
from httplib import HTTPMessage
import StringIO
import zlib
out = os.getenv('PROCDOTPLUGIN_ResultTXT')
try:
    from easygui import *
except:
    e = str("easygui library not found, please install it before proceeding\nPlease run pip install easygui")
    open(out, 'w').write(e)
    exit(0)

temp = os.getenv('LOCALAPPDATA')+'\\temp\\tcpflow_out\\'

def ext(header):
    if 'MZ' in header:
        return '.mz'
    else:
        return '.bin'

def extn():
    ending = (('.ez', '.aw', '.atom', '.atomcat', '.atomsvc', '.ccxml', '.cdmia', '.cdmic', '.cdmid', '.cdmio', '.cdmiq', '.cu', '.davmount', '.dssc', '.xdssc', '.ecma', '.emma', '.epub', '.exi', '.pfr', '.stk', '.ipfix', '.jar', '.ser', '.class', '.js', '.json', '.lostxml', '.hqx', '.cpt', '.mads', '.mrc', '.mrcx', '.mb', '.mathml', '.mbox', '.mscml', '.meta4', '.mets', '.mods', '.mp21', '.mp4s', '.doc', '.mxf', '.oda', '.opf', '.ogx', '.onetoc', '.xer', '.pdf', '.pgp', '.asc', '.prf', '.p10', '.p7m', '.p7s', '.p8', '.ac', '.cer', '.crl', '.pkipath', '.pki', '.pls', '.ps', '.cww', '.pskcxml', '.rdf', '.rif', '.rnc', '.rl', '.rld', '.rs', '.rsd', '.rss', '.rtf', '.sbml', '.scq', '.scs', '.spq', '.spp', '.sdp', '.setpay', '.setreg', '.shf', '.smil', '.rq', '.srx', '.gram', '.grxml', '.sru', '.ssml', '.teicorpus', '.tfi', '.tsd', '.plb', '.psb', '.pvb', '.tcap', '.pwn', '.aso', '.imp', '.acu', '.atc', '.air', '.fxp', '.xdp', '.xfdf', '.ahead', '.azf', '.azs', '.azw', '.acc', '.ami', '.apk', '.cii', '.fti', '.atx', '.mpkg', '.m3u8', '.swi', '.aep', '.mpm', '.bmi', '.rep', '.cdxml', '.mmd', '.cdy', '.cla', '.rp9', '.c4g', '.c11amc', '.c11amz', '.csp', '.cdbcmsg', '.cmc', '.clkx', '.clkk', '.clkp', '.clkt', '.clkw', '.wbs', '.pml', '.ppd', '.car', '.pcurl', '.rdz', '.fe_launch', '.dna', '.mlp', '.dpg', '.dfac', '.ait', '.svc', '.geo', '.mag', '.nml', '.esf', '.msf', '.qam', '.slt', '.ssf', '.es3', '.ez2', '.ez3', '.fdf', '.mseed', '.seed', '.gph', '.ftc', '.fm', '.fnc', '.ltf', '.fsc', '.oas', '.oa2', '.oa3', '.fg5', '.bh2', '.ddd', '.xdw', '.xbd', '.fzs', '.txd', '.ggb', '.ggt', '.gex', '.gxt', '.g2w', '.g3w', '.gmx', '.kml', '.kmz', '.gqf', '.gac', '.ghf', '.gim', '.grv', '.gtm', '.tpl', '.vcg', '.hal', '.zmm', '.hbci', '.les', '.hpgl', '.hpid', '.hps', '.jlt', '.pcl', '.pclxl', '.sfd-hdstx', '.x3d', '.mpy', '.afp', '.irm', '.sc', '.icc', '.igl', '.ivp', '.ivu', '.igm', '.xpw', '.i2g', '.qbo', '.qfx', '.rcprofile', '.irp', '.xpr', '.fcs', '.jam', '.rms', '.jisp', '.joda', '.ktz', '.karbon', '.chrt', '.kfo', '.flw', '.kon', '.kpr', '.ksp', '.kwd', '.htke', '.kia', '.knp', '.skp', '.sse', '.lasxml', '.lbd', '.lbe', '.123', '.apr', '.pre', '.nsf', '.org', '.scm', '.lwp', '.portpkg', '.mcd', '.mc1', '.cdkey', '.mwf', '.mfm', '.flo', '.igx', '.mif', '.daf', '.dis', '.mbk', '.mqy', '.msl', '.plc', '.txf', '.mpn', '.mpc', '.xul', '.cil', '.cab', '.xls', '.xlam', '.xlsb', '.xlsm', '.xltm', '.eot', '.chm', '.ims', '.lrm', '.thmx', '.cat', '.stl', '.ppt', '.ppam', '.pptm', '.sldm', '.ppsm', '.potm', '.mpp', '.docm', '.dotm', '.wps', '.wpl', '.xps', '.mseq', '.mus', '.msty', '.nlu', '.nnd', '.nns', '.nnw', '.ngdat', '.n-gage', '.rpst', '.rpss', '.edm', '.edx', '.ext', '.odc', '.otc', '.odb', '.odf', '.odft', '.odg', '.otg', '.odi', '.oti', '.odp', '.otp', '.ods', '.ots', '.odt', '.odm', '.ott', '.oth', '.xo', '.dd2', '.oxt', '.pptx', '.sldx', '.ppsx', '.potx', '.xlsx', '.xltx', '.docx', '.dotx', '.mgp', '.dp', '.pdb', '.paw', '.str', '.ei6', '.efif', '.wg', '.plf', '.pbd', '.box', '.mgz', '.qps', '.ptid', '.qxd', '.bed', '.mxl', '.musicxml', '.cryptonote', '.cod', '.rm', '.link66', '.st', '.see', '.sema', '.semd', '.semf', '.ifm', '.itp', '.iif', '.ipk', '.twd', '.mmf', '.teacher', '.sdkm', '.dxp', '.sfs', '.sdc', '.sda', '.sdd', '.smf', '.sdw', '.sgl', '.sm', '.sxc', '.stc', '.sxd', '.std', '.sxi', '.sti', '.sxm', '.sxw', '.sxg', '.stw', '.sus', '.svd', '.sis', '.xsm', '.bdm', '.xdm', '.tao', '.tmo', '.tpt', '.mxs', '.tra', '.ufdl', '.utz', '.umj', '.unityweb', '.uoml', '.vcx', '.vsd', '.vis', '.vsf', '.wbxml', '.wmlc', '.wmlsc', '.wtb', '.nbp', '.wpd', '.wqd', '.stf', '.xar', '.xfdl', '.hvd', '.hvs', '.hvp', '.osf', '.osfpvg', '.saf', '.spf', '.cmp', '.zir', '.zaz', '.vxml', '.wgt', '.hlp', '.wsdl', '.wspolicy', '.7z', '.abw', '.ace', '.aam', '.aas', '.bcpio', '.torrent', '.bz', '.bz2', '.vcd', '.chat', '.pgn', '.cpio', '.csh', '.deb', '.dir', '.wad', '.ncx', '.dtb', '.res', '.dvi', '.bdf', '.gsf', '.psf', '.otf', '.pcf', '.snf', '.ttf', '.afm', '.woff', '.spl', '.gnumeric', '.gtar', '.hdf', '.jnlp', '.latex', '.mobi', '.m3u8', '.application', '.wmd', '.wmz', '.xbap', '.mdb', '.obd', '.crd', '.clp', '.mvb', '.wmf', '.mny', '.pub', '.scd', '.trm', '.wri', '.nc', '.p12', '.p7b', '.p7r', '.rar', '.sh', '.shar', '.swf', '.xap', '.sit', '.sitx', '.sv4cpio', '.sv4crc', '.tar', '.tcl', '.tex', '.tfm', '.texi', '.ustar', '.src', '.crt', '.fig', '.xpi', '.xdf', '.xenc', '.xhtml', '.xml', '.dtd', '.xop', '.xslt', '.xspf', '.xvml', '.yang', '.yin', '.zip', '.adp', '.au', '.mid', '.mp4a', '.m4a', '.mpga', '.ogg', '.uvva', '.eol', '.dra', '.dts', '.dtshd', '.lvp', '.pya', '.ecelp4800', '.ecelp7470', '.ecelp9600', '.rip', '.weba', '.aac', '.aiff', '.m3u', '.wax', '.wma', '.ram', '.rmp', '.wav', '.cdx', '.cif', '.cmdf', '.cml', '.csml', '.xyz', '.bmp', '.cgm', '.g3', '.gif', '.ief', '.jp2', '.jpg', '.ktx', '.pict', '.png', '.btif', '.svg', '.tiff', '.psd', '.uvi', '.djvu', '.sub', '.dwg', '.dxf', '.fbs', '.fpx', '.fst', '.mmr', '.rlc', '.mdi', '.npx', '.wbmp', '.xif', '.webp', '.ras', '.cmx', '.fh', '.ico', '.pntg', '.pcx', '.pict', '.pnm', '.pbm', '.pgm', '.ppm', '.qtif', '.rgb', '.xbm', '.xpm', '.xwd', '.eml', '.iges', '.mesh', '.dae', '.dwf', '.gdl', '.gtw', '.mts', '.vtu', '.vrml', '.manifest', '.ics', '.css', '.csv', '.html', '.n3', '.txt', '.dsc', '.rtx', '.sgml', '.tsv', '.roff', '.ttl', '.urls', '.curl', '.dcurl', '.mcurl', '.scurl', '.fly', '.flx', '.gv', '.3dml', '.spot', '.jad', '.wml', '.wmls', '.asm', '.c', '.f', '.java', '.pas', '.etx', '.uu', '.vcs', '.vcf', '.3gp', '.3g2', '.h261', '.h263', '.h264', '.jpgv', '.jpm', '.mj2', '.ts', '.m4v', '.mpg', '.ogv', '.mov', '.uvvh', '.uvvm', '.uvvp', '.uvvs', '.uvvv', '.fvt', '.m4u', '.pyv', '.uvvu', '.viv', '.webm', '.dv', '.f4v', '.fli', '.flv', '.m4v', '.asf', '.wm', '.wmv', '.wmx', '.wvx', '.avi', '.movie', '.ice'))
    return ending

def parse_files(temp,path,IP):
    if IP == None:
        for infile in os.listdir(temp):
            if 'HTTPBODY' in infile:
                if infile.endswith(extn()):
                    os.chdir(path)
                    shutil.move((temp+infile),(infile))
                else:
                    try:
                        with open(temp+infile, 'rb') as temp_file:
                            end = ext(temp_file.read(20))
                            temp_file.close()
                            os.chdir(path)
                            shutil.move((temp+infile),(infile+end))
                    except:
                        pass
    else:
        folder = str(os.listdir(temp))
        if IP in folder:
            for infile in os.listdir(temp):
                if 'HTTPBODY' in infile:
                    if IP in infile:
                        if infile.endswith(extn()):
                            os.chdir(path)
                            shutil.move((temp+infile),(infile))
                        else:
                            try:
                                with open(temp+infile, 'rb') as temp_file:
                                    end = ext(temp_file.read(20))
                                    temp_file.close()
                                    os.chdir(path)
                                    shutil.move((temp+infile),(infile+end))
                            except:
                                pass
        else:
            e = str("No files found.")
            open(out,'ab').write(e)

def parse_flow(IP):
    for infile in os.listdir(temp):
        if 'HTTPBODY' not in infile:
            if IP in infile:
                merge = open(temp+infile,'rb').read().replace('\0', '.') +'\n\n'
                open(out,'ab').write(merge)
    else:
        e = str("No tcp flows found for ")+IP
        open(out,'ab').write(e)

def MD5(path,reply):
    for infile in os.listdir(path):
        if reply == 'MD5':
            h = hashlib.md5()
        elif reply == 'SHA1':
            h = hashlib.sha1()
        elif reply == 'SHA256':
            h = hashlib.sha256()
        with open (infile, 'rb') as afile:
            buf = afile.read()
            h.update(buf)
            output = h.hexdigest()
            afile.close()
        filename, fileExtention = os.path.splitext(infile)
        shutil.move(infile,output+fileExtention)

def gui(reply,path):
    while 1:
        msg = 'Select hash type:'
        title = 'Extract files from pcap'
        choices = ['MD5','SHA1','SHA256']
        reply = buttonbox(msg,title,choices=choices)
        path = diropenbox(msg='Select output folder',title=title,default=os.getcwd())
        if reply and path != None:
            return reply,path
        else:
            exit(0)

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
        exit(0)

def gzip_deflate(temp,IP):
    for infile in os.listdir(temp):
        if 'HTTPBODY' not in infile:
            if IP in infile:
                try:
                    d = zlib.decompressobj(16+zlib.MAX_WBITS)
                    f = open(temp+infile, 'rb')
                    status_line = f.readline()
                    msg = HTTPMessage(f, 0)
                    isGZipped = msg.get('content-encoding', '').find('gzip') >= 0
                    isChunked = msg.get('Transfer-Encoding', '').find('chunked') >= 0
                    if isGZipped and isChunked:
                        offset = msg.fp.readline()
                        body = msg.fp.read()
                        num = int(offset, 16)
                        encdata = ''
                        newdata = ''
                        encdata =body[:num]
                        newdata = d.decompress(encdata)
                        header = str(msg)
                        outfile = open(temp+infile, 'wb')
                        outfile.write(status_line)
                        outfile.write(header)
                        outfile.write('\n')
                        outfile.write(newdata)
                        outfile.close()
                    elif isGZipped:
                        body = msg.fp.read()
                        data = d.decompress(body)
                        header = str(msg)
                        outfile = open(temp+infile, 'wb')
                        outfile.write(status_line)
                        outfile.write(header)
                        outfile.write('\n')
                        outfile.write(data)
                        outfile.close()
                    else:
                        f.close()
                except:
                    outfile = open(temp+infile,'rb+')
                    outfile.write('DECOMPRESSION ERROR')
                    outfile.write('\n\n')
                    outfile.write(status_line)
                    outfile.write(temp+infile)
                    outfile.close()

def check_tcpflow_ver():
    try:
        p = sub.Popen(['tcpflow', '-V'], stdout=sub.PIPE, stderr=sub.PIPE)
        check = p.communicate()[0] 
        if 'tcpflow 1.' not in check.lower() and 'tcpflow 2.' not in check.lower():
            e = str("[ERROR] Please download 1.0 or higer\nDownload: https://github.com/simsong/tcpflow/")
            open(out,'ab').write(e)
            exit(0)
    except:
        e = str("[ERROR] TCPflow missing. Please download 1.0 or higer.\nDownload: https://github.com/simsong/tcpflow/")
        open(out,'w').write(e)
        exit(0)

def chunk_check(temp,IP):
    for infile in os.listdir(temp):
        if 'HTTPBODY' not in infile:
            if IP in infile:
                try:
                    f = open(temp+infile, 'rb')
                    status_line = f.readline()
                    msg = HTTPMessage(f, 0)
                    isGZipped = msg.get('content-encoding', '').find('gzip') >= 0
                    isChunked = msg.get('Transfer-Encoding', '').find('chunked') >= 0
                    if isGZipped and isChunked:
                            outfile = open(temp+infile, 'rb').read().split('HTTP')
                            at = 1
                            for lines in range(2, len(outfile)):
                                outputData = outfile[lines]
                                output = open(temp + infile + '_' + str(at), 'wb')
                                output.write('HTTP' + outputData)
                                output.close()
                                at += 1
                except:
                    pass
                    
def main():
    reply = None
    path = None
    IP = None
    if os.getenv('PROCDOTPLUGIN_VerificationRun') == None:
        check_tcpflow_ver()
        if os.getenv('PROCDOTPLUGIN_Name') == 'Extract Files From PCAP':
            p = sub.Popen(['tcpflow', '-T %N_%A-%B', '-o', (temp), '-ar', (os.getenv('PROCDOTPLUGIN_WindumpFilePcap'))], stdout=sub.PIPE, stderr=sub.PIPE)
            p.wait()
            reply,path = gui(reply,path)
            parse_files(temp,path,IP)
            MD5(path,reply)
            shutil.rmtree(temp)
        elif os.getenv('PROCDOTPLUGIN_Name') == 'Follow TCP Stream':
            p = sub.Popen(['tcpflow', '-T %N_%A-%B', '-o', (temp), '-ar', (os.getenv('PROCDOTPLUGIN_WindumpFilePcap'))], stdout=sub.PIPE, stderr=sub.PIPE)
            p.wait()
            IP = os.getenv('PROCDOTPLUGIN_CurrentNode_Details_IP-Address')
            IP = parse_IP(IP)
            chunk_check(temp,IP)
            gzip_deflate(temp,IP)
            parse_flow(IP)
            shutil.rmtree(temp)
        else:
            p = sub.Popen(['tcpflow', '-T %N_%A-%B', '-o', (temp), '-ar', (os.getenv('PROCDOTPLUGIN_WindumpFilePcap'))], stdout=sub.PIPE, stderr=sub.PIPE)
            p.wait()
            reply,path = gui(reply,path)
            IP = os.getenv('PROCDOTPLUGIN_CurrentNode_Details_IP-Address')
            IP = parse_IP(IP)
            parse_files(temp,path,IP)
            MD5(path,reply)
            shutil.rmtree(temp)
    else:
        if os.getenv('PROCDOTPLUGIN_CurrentNode_name')[:6] == 'SERVER':
            exit(1)
        else:
            exit(0)
            
if __name__ == '__main__':
    main()