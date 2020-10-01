HOW TO SETUP ST-Ericsson STA2500D Bluetooth device
==================================================

The Bluetooth device STA2500D is connected on the MSP port 3 of the ConneXt IO-Hub. 

Two files are released with this package which can be downloaded to the STLC2500 chip.
•	STLC2500_R5_03_A17.PTC patch File: it is a binary file containing a header part and the actual patches. 
  This is an AXF image built in a similar way as the STLC2500 FW.
•	STLC2500_R5_03_03_masterpcm_clkinvert.ssf: it contains product & application specific parameters 
  (values are defined by the customer) , as well as system parameters (for optimal BB/RF functionality). 
  These settings are valid for all STLC2500 chips. The file is typically stored in the Host file system


Device Setup steps:
===================

1. Copy the BT static setting file STLC2500_R5_03_03_masterpcm_clkinvert.ssf into the /lib/firmware folder
2. Copy the BT firmware patch STLC2500_R5_03_A17.ptc into the /lib/firmware folder
3. load the hci_uart driver:
   #modprobe hci_uart
4. execute the hciattach command:
   # hciattach /dev/ttyAM0 stlc2500 115200

STLC2500 R5.3 05102007 08:20:56 ZAV100131  HW Id= 0xF1
Loading file /lib/firmware/STLC2500_R5_03_A17.ptc
Loading file /lib/firmware/STLC2500_R5_03_03_masterpcm_clkinvert.ssf
Device setup complete

4. execute the hci_reset command:
	# hcitool -i hci0 cmd 01 03 0c 00

   < HCI Command: ogf 0x01, ocf 0x0003, plen 2
     0C 00 
   > HCI Event: 0x0e plen 4
     02 03 04 12 

6. enable it with hciconfig:

[root@stuser-desktop stuser]# hciconfig hci0 up
[root@stuser-desktop stuser]# hciconfig
hci0:   Type: UART
       BD Address: 00:80:E1:00:AB:BA ACL MTU: 1021:4 SCO MTU: 64:255
       UP RUNNING PSCAN
       RX bytes:1034 acl:0 sco:0 events:33 errors:0
       TX bytes:1380 acl:0 sco:0 commands:33 errors:0

921600 Baudrate configuration
=============================

replace step 4. with the two following commands:
 #hciattach /dev/ttyAM0 -s 115200 stlc2500 921600 flow
 #hcitool -i hci0 cmd 3f fc 01 14
