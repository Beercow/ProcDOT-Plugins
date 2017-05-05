# PCAP Tools [![Flattr this git repo](http://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/submit/auto?user_id=beercow&url=https://github.com/Beercow/ProcDOT-Plugins) 
\* Due to slight variations in the plugin engine, be sure to download the plugin for the right version of ProcDOT

## Project source can be downloaded from
https://github.com/Beercow/ProcDOT-Plugins/tree/master/PCAP_tools
## Author & Contributor List
Brian Maloney

## Overview
PCAP_tools is a set of plugins to add functionality to ProcDOT. With this plugin, you will be able to dump files from the pcap and view flows in ProcDOT. TCPflow is used with the plugin to accomplish this.

### Setup
Download files from the repository for your system. Move the pcap_tools(.py) and pdp fles into you ProcDOT plugins directory. These plugins depend on Python 2.7 and tcpflow 1.4.4 or later (http://www.digitalcorpora.org/downloads/tcpflow/). Place the tcpflow executable either in the plugin folder or from a system callable path. On Windows, make sure the pcap_tools.bat contains the rihgt path to for python.

![2016-12-16_8-08-19](https://cloud.githubusercontent.com/assets/10360919/21265427/124a660c-c367-11e6-849a-a9c5951ae267.png)

Fire up ProcDOT and there should an entry in the Plugin menu called **Extract Files From PCAP**, and a right click option on a server node labeled **Follow TCP Stream** and **Extract File(s) From Flow**.

#### Extract Files From PCAP
Extract Files From PCAP is controled by pcap_tools_files.pdp. With this config file in the ProcDOT plugins folder, there should now be an entry in the plugins menu.

![Plugins Menu](https://cloud.githubusercontent.com/assets/10360919/12631017/e049998a-c514-11e5-9e4a-31a35ff9dc4a.png)

This plugin will allow you to extract files that are contained in pcap file loaded in ProcDOT. Once selected, a new window will open asking you which hash algorithum you want to use(MD5, SHA1, SHA256). Once you are done picking a hash, it will ask for folder to save the files in.

![pcap_tools_gui](https://cloud.githubusercontent.com/assets/10360919/21141301/fc566b28-c101-11e6-8c83-ce9b6506e552.png) ![Save Folder](https://cloud.githubusercontent.com/assets/10360919/12631019/e054af64-c514-11e5-8f95-033de6bbaffd.PNG)

If there are files in the pcap, they should be hashed accordingly in the save folder.
![Hashed Files](https://cloud.githubusercontent.com/assets/10360919/12631022/e05d782e-c514-11e5-9092-dda6f2d10e03.PNG)

#### Follow TCP Stream
Follow TCP Stream is controled by pcap_tools_stream.pdp. With this config file loaded in ProcDOT plugins folder, there should now be an entry in the right click menu when you are on a server node.
![Server Node Right Click Menu](https://cloud.githubusercontent.com/assets/10360919/12631020/e055c520-c514-11e5-9f1f-c8a7933f6453.png)

The plugin will allow you to view complete flows natively in ProcDOT. They will look simular to viewing them in Wireshark.

![Wireshark Stream View](https://cloud.githubusercontent.com/assets/10360919/12631025/e069edc0-c514-11e5-8180-f44c41e74632.PNG) ![ProcDOT Stream View](https://cloud.githubusercontent.com/assets/10360919/12631023/e0626f0a-c514-11e5-8d04-4a0d5ce22cde.png)

Also, if a stream contains gzipped data, Follow TCP Stream should automagically ungzip the stream.

![Wireshark gzip data](https://cloud.githubusercontent.com/assets/10360919/12631026/e0710d6c-c514-11e5-9c38-08c083045183.PNG) ![ProcDOT gzip data](https://cloud.githubusercontent.com/assets/10360919/12631024/e067964c-c514-11e5-983c-632997c5ba09.png)

#### Extract File(s) From Flow
Extract File(s) From Flow is controled by pcap_tools_stream_file.pdp, With this config file loaded in ProcDOT plugins folder, there should now be an entry in the right click menu when you are on a server node.

The plugin will allow you to extract the files from the flow. Once selected, a new window will open asking you which hash algorithum you want to use(MD5, SHA1, SHA256). Once you are done picking a hash, it will ask for folder to save the files in.

If there are files in the flow, they should be hashed accordingly in the save folder.
## Bugs
