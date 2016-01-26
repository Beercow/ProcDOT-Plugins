#PCAP Tools#

##Project source can be downloaded from##
https://github.com/Beercow/ProcDOT-Plugins/tree/master/PCAP_tools
##Author & Contributor List##
Brian Maloney

##File List##
```
.:

README.md

./Linux

./Windows
```
```
/Linux:

pcap_tools

pcap_tools_files.pdp

pcap_tools_streams.pdp
```
```
/Windows:

pcap_tools.py

pcap_tools_files.pdp

pcap_tools_streams.pdp
```

##Overview##
PCAP_tools is a set of plugins to add functionality to ProcDOT. With this plugin, you will be able to dump files from the pcap and vew flows in ProcDOT. TCPflow is used with the plugin to accomplish this.

###Setup###
Download files from the repository for your system. Move the pcap_tools(.py) and pdp fles into you ProcDOT plugins directory. These plugins depend on Python 2.7, easygui for python `pip install easygui`, and tcpflow 1.4.4 or later (http://www.digitalcorpora.org/downloads/tcpflow/). Place the tcpflow executable either in the plugin folder or from a system callable path. Fire up ProcDOT and there should an entry in the Plugin menu called **Extract Files From PCAP**, and a right click onption on the graph labeled **Follow TCP Stream**.

###Using the plugins###
####Extract Files From PCAP####
####Follow TCP Stream####


##Bugs##
* Get Follow TCP Stream to show up only on server nodes
