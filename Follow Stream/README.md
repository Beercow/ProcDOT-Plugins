Follow stream allows you to view packet data with ProcDOT. Currently only the Windows plugin is done at this time. This plugin depends on tcpflow. You can find the Windows binary here: www.digitalcorpora.org/downloads/tcpflow/tcpflow-1.4.4.zip After tcpflow is installed, edit the follow_flow.bat file, replacing set tcpflow=<path to tcpflow> with the path to tcpflow. This plugin shows up in the right click context menu. Right click on a server node andselect follow stream. A new window in ProcDOT will open showing the PCAP data for the selected node. If a window does not open, there was not data in the tcp udp stream.

Update:
Linux plugin is complete, but a little buggy. Should be able to fix issues when ProcDOT 1.2 is released. Please note, tcplfow 1.4.4 is required.

ToDo:
Add ability to ungzip data 
Add message if no data is found(instead of showing no feedback) 
Check to see if tcpflow is installed and the right version. 
