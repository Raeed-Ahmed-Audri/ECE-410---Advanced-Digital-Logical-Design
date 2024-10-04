# File saved with Nlview 7.0r6  2020-01-29 bk=1.5227 VDI=41 GEI=36 GUI=JA:10.0 non-TLS-threadsafe
# 
# non-default properties - (restore without -noprops)
property attrcolor #000000
property attrfontsize 8
property autobundle 1
property backgroundcolor #ffffff
property boxcolor0 #000000
property boxcolor1 #000000
property boxcolor2 #000000
property boxinstcolor #000000
property boxpincolor #000000
property buscolor #008000
property closeenough 5
property createnetattrdsp 2048
property decorate 1
property elidetext 40
property fillcolor1 #ffffcc
property fillcolor2 #dfebf8
property fillcolor3 #f0f0f0
property gatecellname 2
property instattrmax 30
property instdrag 15
property instorder 1
property marksize 12
property maxfontsize 12
property maxzoom 5
property netcolor #19b400
property objecthighlight0 #ff00ff
property objecthighlight1 #ffff00
property objecthighlight2 #00ff00
property objecthighlight3 #0095ff
property objecthighlight4 #8000ff
property objecthighlight5 #ffc800
property objecthighlight7 #00ffff
property objecthighlight8 #ff00ff
property objecthighlight9 #ccccff
property objecthighlight10 #0ead00
property objecthighlight11 #cefc00
property objecthighlight12 #9e2dbe
property objecthighlight13 #ba6a29
property objecthighlight14 #fc0188
property objecthighlight15 #02f990
property objecthighlight16 #f1b0fb
property objecthighlight17 #fec004
property objecthighlight18 #149bff
property objecthighlight19 #eb591b
property overlapcolor #19b400
property pbuscolor #000000
property pbusnamecolor #000000
property pinattrmax 20
property pinorder 2
property pinpermute 0
property portcolor #000000
property portnamecolor #000000
property ripindexfontsize 8
property rippercolor #000000
property rubberbandcolor #000000
property rubberbandfontsize 12
property selectattr 0
property selectionappearance 2
property selectioncolor #0000ff
property sheetheight 44
property sheetwidth 68
property showmarks 1
property shownetname 0
property showpagenumbers 1
property showripindex 4
property timelimit 1
#
module new XOR_Testbench work:XOR_Testbench:NOFILE -nosplit
load symbol XOR_Encryption work:XOR_Encryption:NOFILE HIERBOX pinBus DATA input.left [7:0] pinBus KEY input.left [7:0] pinBus OUT_DATA output.right [7:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol XOR_Decryption work:XOR_Decryption:NOFILE HIERBOX pinBus DECRYPTED_DATA output.right [7:0] pinBus ENCRYPTED_DATA input.left [7:0] pinBus KEY input.left [7:0] boxcolor 1 fillcolor 2 minwidth 13%
load inst U1 XOR_Encryption work:XOR_Encryption:NOFILE -autohide -attr @cell(#000000) XOR_Encryption -pinBusAttr DATA @name DATA[7:0] -pinBusAttr DATA @attr V=B\"11011011\" -pinBusAttr KEY @name KEY[7:0] -pinBusAttr KEY @attr V=B\"10110011\" -pinBusAttr OUT_DATA @name OUT_DATA[7:0] -pg 1 -lvl 1 -x 210 -y 60
load inst U2 XOR_Decryption work:XOR_Decryption:NOFILE -autohide -attr @cell(#000000) XOR_Decryption -pinBusAttr DECRYPTED_DATA @name DECRYPTED_DATA[7:0] -pinBusAttr DECRYPTED_DATA @attr n/c -pinBusAttr ENCRYPTED_DATA @name ENCRYPTED_DATA[7:0] -pinBusAttr KEY @name KEY[7:0] -pinBusAttr KEY @attr V=B\"10110011\" -pg 1 -lvl 2 -x 560 -y 60
load net <const0> -ground -pin U1 DATA[5] -pin U1 DATA[2] -pin U1 KEY[6] -pin U1 KEY[3] -pin U1 KEY[2] -pin U2 KEY[6] -pin U2 KEY[3] -pin U2 KEY[2]
load net <const1> -power -pin U1 DATA[7] -pin U1 DATA[6] -pin U1 DATA[4] -pin U1 DATA[3] -pin U1 DATA[1] -pin U1 DATA[0] -pin U1 KEY[7] -pin U1 KEY[5] -pin U1 KEY[4] -pin U1 KEY[1] -pin U1 KEY[0] -pin U2 KEY[7] -pin U2 KEY[5] -pin U2 KEY[4] -pin U2 KEY[1] -pin U2 KEY[0]
load net ENCRYPTED_DATA[0] -attr @rip OUT_DATA[0] -pin U1 OUT_DATA[0] -pin U2 ENCRYPTED_DATA[0]
load net ENCRYPTED_DATA[1] -attr @rip OUT_DATA[1] -pin U1 OUT_DATA[1] -pin U2 ENCRYPTED_DATA[1]
load net ENCRYPTED_DATA[2] -attr @rip OUT_DATA[2] -pin U1 OUT_DATA[2] -pin U2 ENCRYPTED_DATA[2]
load net ENCRYPTED_DATA[3] -attr @rip OUT_DATA[3] -pin U1 OUT_DATA[3] -pin U2 ENCRYPTED_DATA[3]
load net ENCRYPTED_DATA[4] -attr @rip OUT_DATA[4] -pin U1 OUT_DATA[4] -pin U2 ENCRYPTED_DATA[4]
load net ENCRYPTED_DATA[5] -attr @rip OUT_DATA[5] -pin U1 OUT_DATA[5] -pin U2 ENCRYPTED_DATA[5]
load net ENCRYPTED_DATA[6] -attr @rip OUT_DATA[6] -pin U1 OUT_DATA[6] -pin U2 ENCRYPTED_DATA[6]
load net ENCRYPTED_DATA[7] -attr @rip OUT_DATA[7] -pin U1 OUT_DATA[7] -pin U2 ENCRYPTED_DATA[7]
load netBundle @ENCRYPTED_DATA 8 ENCRYPTED_DATA[7] ENCRYPTED_DATA[6] ENCRYPTED_DATA[5] ENCRYPTED_DATA[4] ENCRYPTED_DATA[3] ENCRYPTED_DATA[2] ENCRYPTED_DATA[1] ENCRYPTED_DATA[0] -autobundled
netbloc @ENCRYPTED_DATA 1 1 1 NJ 70
levelinfo -pg 1 0 210 560 660
pagesize -pg 1 -db -bbox -sgen 0 0 660 150
show
fullfit
#
# initialize ictrl to current module XOR_Testbench work:XOR_Testbench:NOFILE
ictrl init topinfo |
