   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.5 - 16 Jun 2021
   3                     ; Generator (Limited) V4.5.3 - 16 Jun 2021
  55                     ; 7 void sendCmd(char cmd) {
  57                     	switch	.text
  58  0000               _sendCmd:
  60  0000 88            	push	a
  61       00000000      OFST:	set	0
  64                     ; 8 	i2c_wr_reg(oled_32_128_adr, 0x80, &cmd, 1);
  66  0001 4b01          	push	#1
  67  0003 96            	ldw	x,sp
  68  0004 1c0002        	addw	x,#OFST+2
  69  0007 89            	pushw	x
  70  0008 ae3c80        	ldw	x,#15488
  71  000b cd0000        	call	_i2c_wr_reg
  73  000e 5b03          	addw	sp,#3
  74                     ; 9 }
  77  0010 84            	pop	a
  78  0011 81            	ret
 123                     ; 11 void sendData(char* data, char count) {
 124                     	switch	.text
 125  0012               _sendData:
 127  0012 89            	pushw	x
 128       00000000      OFST:	set	0
 131                     ; 12 	i2c_wr_reg(oled_32_128_adr, 0x40, data, count);
 133  0013 7b05          	ld	a,(OFST+5,sp)
 134  0015 88            	push	a
 135  0016 89            	pushw	x
 136  0017 ae3c40        	ldw	x,#15424
 137  001a cd0000        	call	_i2c_wr_reg
 139  001d 5b03          	addw	sp,#3
 140                     ; 13 }
 143  001f 85            	popw	x
 144  0020 81            	ret
 147                     .const:	section	.text
 148  0000               L15_initCmds:
 149  0000 ae            	dc.b	174
 150  0001 20            	dc.b	32
 151  0002 00            	dc.b	0
 152  0003 c0            	dc.b	192
 153  0004 a0            	dc.b	160
 154  0005 b0            	dc.b	176
 155  0006 00            	dc.b	0
 156  0007 10            	dc.b	16
 157  0008 40            	dc.b	64
 158  0009 81            	dc.b	129
 159  000a 7f            	dc.b	127
 160  000b a6            	dc.b	166
 161  000c a8            	dc.b	168
 162  000d 3f            	dc.b	63
 163  000e a4            	dc.b	164
 164  000f d3            	dc.b	211
 165  0010 00            	dc.b	0
 166  0011 d5            	dc.b	213
 167  0012 f0            	dc.b	240
 168  0013 d9            	dc.b	217
 169  0014 22            	dc.b	34
 170  0015 da            	dc.b	218
 171  0016 02            	dc.b	2
 172  0017 db            	dc.b	219
 173  0018 20            	dc.b	32
 174  0019 8d            	dc.b	141
 175  001a 14            	dc.b	20
 176  001b af            	dc.b	175
 220                     ; 15 void init_ssd1306() {  
 221                     	switch	.text
 222  0021               _init_ssd1306:
 224  0021 521d          	subw	sp,#29
 225       0000001d      OFST:	set	29
 228                     ; 17    char initCmds[] = {0xAE,0x20,0x00,0xC0,0xA0,  0xB0,0x00,0x10,0x40,0x81,     0x7F,                0xA6,0xA8,0x3F,0xA4,
 228                     ; 18                       0xD3,0x00,0xD5,0XF0,0xD9,  0x22,0xDA,0x02,0xDB,0x20,  0x8D, 0x14, 0xAF};
 230  0023 96            	ldw	x,sp
 231  0024 1c0001        	addw	x,#OFST-28
 232  0027 90ae0000      	ldw	y,#L15_initCmds
 233  002b a61c          	ld	a,#28
 234  002d cd0000        	call	c_xymov
 236                     ; 19    for(i=0;i<28;i++) sendCmd(initCmds[i]);
 238  0030 0f1d          	clr	(OFST+0,sp)
 240  0032               L57:
 243  0032 96            	ldw	x,sp
 244  0033 1c0001        	addw	x,#OFST-28
 245  0036 9f            	ld	a,xl
 246  0037 5e            	swapw	x
 247  0038 1b1d          	add	a,(OFST+0,sp)
 248  003a 2401          	jrnc	L21
 249  003c 5c            	incw	x
 250  003d               L21:
 251  003d 02            	rlwa	x,a
 252  003e f6            	ld	a,(x)
 253  003f adbf          	call	_sendCmd
 257  0041 0c1d          	inc	(OFST+0,sp)
 261  0043 7b1d          	ld	a,(OFST+0,sp)
 262  0045 a11c          	cp	a,#28
 263  0047 25e9          	jrult	L57
 264                     ; 20    oled_Clear_Screen();
 266  0049 ad14          	call	_oled_Clear_Screen
 268                     ; 21 }
 271  004b 5b1d          	addw	sp,#29
 272  004d 81            	ret
 308                     ; 23 void set_brightness_ssd1306(char brightness) {
 309                     	switch	.text
 310  004e               _set_brightness_ssd1306:
 312  004e 88            	push	a
 313       00000000      OFST:	set	0
 316                     ; 24 	sendCmd(0x81);
 318  004f a681          	ld	a,#129
 319  0051 adad          	call	_sendCmd
 321                     ; 25 	sendCmd(brightness >> 1);
 323  0053 7b01          	ld	a,(OFST+1,sp)
 324  0055 44            	srl	a
 325  0056 ada8          	call	_sendCmd
 327                     ; 26 }
 330  0058 84            	pop	a
 331  0059 81            	ret
 366                     ; 28 void blankScreen(char n) {
 367                     	switch	.text
 368  005a               _blankScreen:
 372                     ; 29   send_repeat_data(0x00,n);
 374  005a 5f            	clrw	x
 375  005b 97            	ld	xl,a
 376  005c ad23          	call	_send_repeat_data
 378                     ; 30 }
 381  005e 81            	ret
 384                     	xref.b	_oledBuffer
 417                     ; 32 void oled_Clear_Screen(void)
 417                     ; 33 { 
 418                     	switch	.text
 419  005f               _oled_Clear_Screen:
 421  005f 88            	push	a
 422       00000001      OFST:	set	1
 425                     ; 36   oled_print_giga_space(0, 128);
 427  0060 ae0080        	ldw	x,#128
 428  0063 cd025a        	call	_oled_print_giga_space
 430                     ; 37   for(i = 0; i < DIG_BUF_SIZE; i++) {oledBuffer.position[i] = EMPTY;}
 432  0066 0f01          	clr	(OFST+0,sp)
 434  0068               L551:
 437  0068 7b01          	ld	a,(OFST+0,sp)
 438  006a 5f            	clrw	x
 439  006b 97            	ld	xl,a
 440  006c a6ff          	ld	a,#255
 441  006e e710          	ld	(_oledBuffer+16,x),a
 445  0070 0c01          	inc	(OFST+0,sp)
 449  0072 7b01          	ld	a,(OFST+0,sp)
 450  0074 a105          	cp	a,#5
 451  0076 25f0          	jrult	L551
 452                     ; 38 }
 455  0078 84            	pop	a
 456  0079 81            	ret
 491                     ; 40 void ff_string(char n) {
 492                     	switch	.text
 493  007a               _ff_string:
 497                     ; 41   send_repeat_data(0xff,n);
 499  007a aeff00        	ldw	x,#65280
 500  007d 97            	ld	xl,a
 501  007e ad01          	call	_send_repeat_data
 503                     ; 42 }
 506  0080 81            	ret
 569                     ; 44 void send_repeat_data(char data_byte, char n) { 
 570                     	switch	.text
 571  0081               _send_repeat_data:
 573  0081 89            	pushw	x
 574  0082 52ff          	subw	sp,#255
 575  0084 5212          	subw	sp,#18
 576       00000111      OFST:	set	273
 579                     ; 47 	for (i=0; i<n; i++) arr[i]=data_byte;
 581  0086 96            	ldw	x,sp
 582  0087 1c0111        	addw	x,#OFST+0
 583  008a 7f            	clr	(x)
 585  008b 2020          	jra	L732
 586  008d               L332:
 589  008d 96            	ldw	x,sp
 590  008e 1c0011        	addw	x,#OFST-256
 591  0091 9f            	ld	a,xl
 592  0092 5e            	swapw	x
 593  0093 9096          	ldw	y,sp
 594  0095 72a90111      	addw	y,#OFST+0
 595  0099 90fb          	add	a,(y)
 596  009b 2401          	jrnc	L62
 597  009d 5c            	incw	x
 598  009e               L62:
 599  009e 02            	rlwa	x,a
 600  009f 9096          	ldw	y,sp
 601  00a1 72a90112      	addw	y,#OFST+1
 602  00a5 90f6          	ld	a,(y)
 603  00a7 f7            	ld	(x),a
 606  00a8 96            	ldw	x,sp
 607  00a9 1c0111        	addw	x,#OFST+0
 608  00ac 7c            	inc	(x)
 609  00ad               L732:
 612  00ad 96            	ldw	x,sp
 613  00ae 1c0111        	addw	x,#OFST+0
 614  00b1 f6            	ld	a,(x)
 615  00b2 96            	ldw	x,sp
 616  00b3 1c0113        	addw	x,#OFST+2
 617  00b6 f1            	cp	a,(x)
 618  00b7 25d4          	jrult	L332
 619                     ; 48 	i2c_wr_reg(oled_32_128_adr, 0x40, arr, n);
 621  00b9 96            	ldw	x,sp
 622  00ba 1c0113        	addw	x,#OFST+2
 623  00bd f6            	ld	a,(x)
 624  00be 88            	push	a
 625  00bf 96            	ldw	x,sp
 626  00c0 1c0012        	addw	x,#OFST-255
 627  00c3 89            	pushw	x
 628  00c4 ae3c40        	ldw	x,#15424
 629  00c7 cd0000        	call	_i2c_wr_reg
 631  00ca 5b03          	addw	sp,#3
 632                     ; 49 }
 635  00cc 5bff          	addw	sp,#255
 636  00ce 5b14          	addw	sp,#20
 637  00d0 81            	ret
 681                     ; 51 void set_cursor(char x, char y) {   
 682                     	switch	.text
 683  00d1               _set_cursor:
 685  00d1 89            	pushw	x
 686       00000000      OFST:	set	0
 689                     ; 52   sendCmd(0x0f&x); 
 691  00d2 9e            	ld	a,xh
 692  00d3 a40f          	and	a,#15
 693  00d5 cd0000        	call	_sendCmd
 695                     ; 53   sendCmd(0x10|(0x0f&(x>>4)));
 697  00d8 7b01          	ld	a,(OFST+1,sp)
 698  00da 4e            	swap	a
 699  00db a40f          	and	a,#15
 700  00dd aa10          	or	a,#16
 701  00df cd0000        	call	_sendCmd
 703                     ; 54   sendCmd(0xb0|y); 
 705  00e2 7b02          	ld	a,(OFST+2,sp)
 706  00e4 aab0          	or	a,#176
 707  00e6 cd0000        	call	_sendCmd
 709                     ; 55 }
 712  00e9 85            	popw	x
 713  00ea 81            	ret
 768                     ; 57 void oled_print_giga_digit(char d, char x, char transparent) {
 769                     	switch	.text
 770  00eb               _oled_print_giga_digit:
 772  00eb 89            	pushw	x
 773       00000000      OFST:	set	0
 776                     ; 58 	if(transparent) oled_print_giga_transparent_digit(d, x);
 778  00ec 0d05          	tnz	(OFST+5,sp)
 779  00ee 270a          	jreq	L313
 782  00f0 9f            	ld	a,xl
 783  00f1 97            	ld	xl,a
 784  00f2 7b01          	ld	a,(OFST+1,sp)
 785  00f4 95            	ld	xh,a
 786  00f5 cd01c7        	call	_oled_print_giga_transparent_digit
 789  00f8 2008          	jra	L513
 790  00fa               L313:
 791                     ; 59 	else          oled_print_giga_solid_digit(d, x);
 793  00fa 7b02          	ld	a,(OFST+2,sp)
 794  00fc 97            	ld	xl,a
 795  00fd 7b01          	ld	a,(OFST+1,sp)
 796  00ff 95            	ld	xh,a
 797  0100 ad02          	call	_oled_print_giga_solid_digit
 799  0102               L513:
 800                     ; 60 }
 803  0102 85            	popw	x
 804  0103 81            	ret
 807                     	switch	.const
 808  001c               L713_const_dig:
 809  001c ff            	dc.b	255
 810  001d 0f            	dc.b	15
 811  001e ff            	dc.b	255
 812  001f ff            	dc.b	255
 813  0020 00            	dc.b	0
 814  0021 ff            	dc.b	255
 815  0022 0f            	dc.b	15
 816  0023 0f            	dc.b	15
 817  0024 0f            	dc.b	15
 818  0025 00            	dc.b	0
 819  0026 00            	dc.b	0
 820  0027 ff            	dc.b	255
 821  0028 00            	dc.b	0
 822  0029 00            	dc.b	0
 823  002a ff            	dc.b	255
 824  002b 00            	dc.b	0
 825  002c 00            	dc.b	0
 826  002d 0f            	dc.b	15
 827  002e 0f            	dc.b	15
 828  002f 0f            	dc.b	15
 829  0030 ff            	dc.b	255
 830  0031 ff            	dc.b	255
 831  0032 0f            	dc.b	15
 832  0033 0f            	dc.b	15
 833  0034 0f            	dc.b	15
 834  0035 0f            	dc.b	15
 835  0036 0f            	dc.b	15
 836  0037 0f            	dc.b	15
 837  0038 0f            	dc.b	15
 838  0039 ff            	dc.b	255
 839  003a 0f            	dc.b	15
 840  003b 0f            	dc.b	15
 841  003c ff            	dc.b	255
 842  003d 0f            	dc.b	15
 843  003e 0f            	dc.b	15
 844  003f 0f            	dc.b	15
 845  0040 ff            	dc.b	255
 846  0041 00            	dc.b	0
 847  0042 ff            	dc.b	255
 848  0043 0f            	dc.b	15
 849  0044 0f            	dc.b	15
 850  0045 ff            	dc.b	255
 851  0046 00            	dc.b	0
 852  0047 00            	dc.b	0
 853  0048 0f            	dc.b	15
 854  0049 ff            	dc.b	255
 855  004a 0f            	dc.b	15
 856  004b 0f            	dc.b	15
 857  004c 0f            	dc.b	15
 858  004d 0f            	dc.b	15
 859  004e ff            	dc.b	255
 860  004f 0f            	dc.b	15
 861  0050 0f            	dc.b	15
 862  0051 0f            	dc.b	15
 863  0052 ff            	dc.b	255
 864  0053 0f            	dc.b	15
 865  0054 0f            	dc.b	15
 866  0055 ff            	dc.b	255
 867  0056 0f            	dc.b	15
 868  0057 ff            	dc.b	255
 869  0058 0f            	dc.b	15
 870  0059 0f            	dc.b	15
 871  005a 0f            	dc.b	15
 872  005b 0f            	dc.b	15
 873  005c 0f            	dc.b	15
 874  005d ff            	dc.b	255
 875  005e 00            	dc.b	0
 876  005f 00            	dc.b	0
 877  0060 ff            	dc.b	255
 878  0061 00            	dc.b	0
 879  0062 00            	dc.b	0
 880  0063 0f            	dc.b	15
 881  0064 ff            	dc.b	255
 882  0065 0f            	dc.b	15
 883  0066 ff            	dc.b	255
 884  0067 ff            	dc.b	255
 885  0068 0f            	dc.b	15
 886  0069 ff            	dc.b	255
 887  006a 0f            	dc.b	15
 888  006b 0f            	dc.b	15
 889  006c 0f            	dc.b	15
 890  006d ff            	dc.b	255
 891  006e 0f            	dc.b	15
 892  006f ff            	dc.b	255
 893  0070 0f            	dc.b	15
 894  0071 0f            	dc.b	15
 895  0072 ff            	dc.b	255
 896  0073 0f            	dc.b	15
 897  0074 0f            	dc.b	15
 898  0075 0f            	dc.b	15
 981                     ; 62 void oled_print_giga_solid_digit(char d, char x) {
 982                     	switch	.text
 983  0104               _oled_print_giga_solid_digit:
 985  0104 89            	pushw	x
 986  0105 5267          	subw	sp,#103
 987       00000067      OFST:	set	103
 990                     ; 63   const char c=4;
 992  0107 a604          	ld	a,#4
 993  0109 6b5d          	ld	(OFST-10,sp),a
 995                     ; 64 	char i=0;
 997                     ; 65   const char const_dig[10][9]={{0xff,0x0f,0xff, 0xff,0x00,0xff, 0x0f,0x0f,0x0f},  //0
 997                     ; 66                                {0x00,0x00,0xff, 0x00,0x00,0xff, 0x00,0x00,0x0f},  //1
 997                     ; 67                                {0x0f,0x0f,0xff, 0xff,0x0f,0x0f, 0x0f,0x0f,0x0f},  //2
 997                     ; 68                                {0x0f,0x0f,0xff, 0x0f,0x0f,0xff, 0x0f,0x0f,0x0f},  //3
 997                     ; 69                                {0xff,0x00,0xff, 0x0f,0x0f,0xff, 0x00,0x00,0x0f},  //4
 997                     ; 70                                {0xff,0x0f,0x0f, 0x0f,0x0f,0xff, 0x0f,0x0f,0x0f},  //5
 997                     ; 71                                {0xff,0x0f,0x0f, 0xff,0x0f,0xff, 0x0f,0x0f,0x0f},  //6
 997                     ; 72                                {0x0f,0x0f,0xff, 0x00,0x00,0xff, 0x00,0x00,0x0f},  //7
 997                     ; 73                                {0xff,0x0f,0xff, 0xff,0x0f,0xff, 0x0f,0x0f,0x0f},  //8
 997                     ; 74                                {0xff,0x0f,0xff, 0x0f,0x0f,0xff, 0x0f,0x0f,0x0f}}; //9
 999  010b 96            	ldw	x,sp
1000  010c 1c0003        	addw	x,#OFST-100
1001  010f 90ae001c      	ldw	y,#L713_const_dig
1002  0113 a65a          	ld	a,#90
1003  0115 cd0000        	call	c_xymov
1005                     ; 76   for (i=0; i<9; i++) dig[i]=const_dig[d][i]; 
1007  0118 0f67          	clr	(OFST+0,sp)
1009  011a               L363:
1012  011a 96            	ldw	x,sp
1013  011b 1c005e        	addw	x,#OFST-9
1014  011e 9f            	ld	a,xl
1015  011f 5e            	swapw	x
1016  0120 1b67          	add	a,(OFST+0,sp)
1017  0122 2401          	jrnc	L63
1018  0124 5c            	incw	x
1019  0125               L63:
1020  0125 02            	rlwa	x,a
1021  0126 89            	pushw	x
1022  0127 96            	ldw	x,sp
1023  0128 1c0005        	addw	x,#OFST-98
1024  012b 1f03          	ldw	(OFST-100,sp),x
1026  012d 7b6a          	ld	a,(OFST+3,sp)
1027  012f 97            	ld	xl,a
1028  0130 a609          	ld	a,#9
1029  0132 42            	mul	x,a
1030  0133 72fb03        	addw	x,(OFST-100,sp)
1031  0136 01            	rrwa	x,a
1032  0137 1b69          	add	a,(OFST+2,sp)
1033  0139 2401          	jrnc	L04
1034  013b 5c            	incw	x
1035  013c               L04:
1036  013c 02            	rlwa	x,a
1037  013d f6            	ld	a,(x)
1038  013e 85            	popw	x
1039  013f f7            	ld	(x),a
1042  0140 0c67          	inc	(OFST+0,sp)
1046  0142 7b67          	ld	a,(OFST+0,sp)
1047  0144 a109          	cp	a,#9
1048  0146 25d2          	jrult	L363
1049                     ; 78   set_cursor(x,0);
1051  0148 7b69          	ld	a,(OFST+2,sp)
1052  014a 5f            	clrw	x
1053  014b 95            	ld	xh,a
1054  014c ad83          	call	_set_cursor
1056                     ; 79   for (i=0 ;i<3; i++) send_repeat_data(dig[i],c);
1058  014e 0f67          	clr	(OFST+0,sp)
1060  0150               L173:
1063  0150 7b5d          	ld	a,(OFST-10,sp)
1064  0152 97            	ld	xl,a
1065  0153 89            	pushw	x
1066  0154 96            	ldw	x,sp
1067  0155 1c0060        	addw	x,#OFST-7
1068  0158 9f            	ld	a,xl
1069  0159 5e            	swapw	x
1070  015a 1b69          	add	a,(OFST+2,sp)
1071  015c 2401          	jrnc	L24
1072  015e 5c            	incw	x
1073  015f               L24:
1074  015f 02            	rlwa	x,a
1075  0160 f6            	ld	a,(x)
1076  0161 85            	popw	x
1077  0162 95            	ld	xh,a
1078  0163 cd0081        	call	_send_repeat_data
1082  0166 0c67          	inc	(OFST+0,sp)
1086  0168 7b67          	ld	a,(OFST+0,sp)
1087  016a a103          	cp	a,#3
1088  016c 25e2          	jrult	L173
1089                     ; 80   set_cursor(x,1);
1091  016e 7b69          	ld	a,(OFST+2,sp)
1092  0170 ae0001        	ldw	x,#1
1093  0173 95            	ld	xh,a
1094  0174 cd00d1        	call	_set_cursor
1096                     ; 81   for (i=3; i<6; i++) send_repeat_data(dig[i],c);
1098  0177 a603          	ld	a,#3
1099  0179 6b67          	ld	(OFST+0,sp),a
1101  017b               L773:
1104  017b 7b5d          	ld	a,(OFST-10,sp)
1105  017d 97            	ld	xl,a
1106  017e 89            	pushw	x
1107  017f 96            	ldw	x,sp
1108  0180 1c0060        	addw	x,#OFST-7
1109  0183 9f            	ld	a,xl
1110  0184 5e            	swapw	x
1111  0185 1b69          	add	a,(OFST+2,sp)
1112  0187 2401          	jrnc	L44
1113  0189 5c            	incw	x
1114  018a               L44:
1115  018a 02            	rlwa	x,a
1116  018b f6            	ld	a,(x)
1117  018c 85            	popw	x
1118  018d 95            	ld	xh,a
1119  018e cd0081        	call	_send_repeat_data
1123  0191 0c67          	inc	(OFST+0,sp)
1127  0193 7b67          	ld	a,(OFST+0,sp)
1128  0195 a106          	cp	a,#6
1129  0197 25e2          	jrult	L773
1130                     ; 82   set_cursor(x,2);
1132  0199 7b69          	ld	a,(OFST+2,sp)
1133  019b ae0002        	ldw	x,#2
1134  019e 95            	ld	xh,a
1135  019f cd00d1        	call	_set_cursor
1137                     ; 83   for (i=6; i<9; i++) send_repeat_data(dig[i],c);
1139  01a2 a606          	ld	a,#6
1140  01a4 6b67          	ld	(OFST+0,sp),a
1142  01a6               L504:
1145  01a6 7b5d          	ld	a,(OFST-10,sp)
1146  01a8 97            	ld	xl,a
1147  01a9 89            	pushw	x
1148  01aa 96            	ldw	x,sp
1149  01ab 1c0060        	addw	x,#OFST-7
1150  01ae 9f            	ld	a,xl
1151  01af 5e            	swapw	x
1152  01b0 1b69          	add	a,(OFST+2,sp)
1153  01b2 2401          	jrnc	L64
1154  01b4 5c            	incw	x
1155  01b5               L64:
1156  01b5 02            	rlwa	x,a
1157  01b6 f6            	ld	a,(x)
1158  01b7 85            	popw	x
1159  01b8 95            	ld	xh,a
1160  01b9 cd0081        	call	_send_repeat_data
1164  01bc 0c67          	inc	(OFST+0,sp)
1168  01be 7b67          	ld	a,(OFST+0,sp)
1169  01c0 a109          	cp	a,#9
1170  01c2 25e2          	jrult	L504
1171                     ; 84 }
1174  01c4 5b69          	addw	sp,#105
1175  01c6 81            	ret
1178                     	switch	.const
1179  0076               L314_const_dig:
1180  0076 ff            	dc.b	255
1181  0077 01            	dc.b	1
1182  0078 01            	dc.b	1
1183  0079 f9            	dc.b	249
1184  007a 09            	dc.b	9
1185  007b 09            	dc.b	9
1186  007c 09            	dc.b	9
1187  007d 09            	dc.b	9
1188  007e f9            	dc.b	249
1189  007f 01            	dc.b	1
1190  0080 01            	dc.b	1
1191  0081 ff            	dc.b	255
1192  0082 ff            	dc.b	255
1193  0083 00            	dc.b	0
1194  0084 00            	dc.b	0
1195  0085 ff            	dc.b	255
1196  0086 00            	dc.b	0
1197  0087 00            	dc.b	0
1198  0088 00            	dc.b	0
1199  0089 00            	dc.b	0
1200  008a ff            	dc.b	255
1201  008b 00            	dc.b	0
1202  008c 00            	dc.b	0
1203  008d ff            	dc.b	255
1204  008e 0f            	dc.b	15
1205  008f 08            	dc.b	8
1206  0090 08            	dc.b	8
1207  0091 09            	dc.b	9
1208  0092 09            	dc.b	9
1209  0093 09            	dc.b	9
1210  0094 09            	dc.b	9
1211  0095 09            	dc.b	9
1212  0096 09            	dc.b	9
1213  0097 08            	dc.b	8
1214  0098 08            	dc.b	8
1215  0099 0f            	dc.b	15
1216  009a 00            	dc.b	0
1217  009b 00            	dc.b	0
1218  009c 00            	dc.b	0
1219  009d 00            	dc.b	0
1220  009e 00            	dc.b	0
1221  009f 00            	dc.b	0
1222  00a0 00            	dc.b	0
1223  00a1 00            	dc.b	0
1224  00a2 ff            	dc.b	255
1225  00a3 01            	dc.b	1
1226  00a4 01            	dc.b	1
1227  00a5 ff            	dc.b	255
1228  00a6 00            	dc.b	0
1229  00a7 00            	dc.b	0
1230  00a8 00            	dc.b	0
1231  00a9 00            	dc.b	0
1232  00aa 00            	dc.b	0
1233  00ab 00            	dc.b	0
1234  00ac 00            	dc.b	0
1235  00ad 00            	dc.b	0
1236  00ae ff            	dc.b	255
1237  00af 00            	dc.b	0
1238  00b0 00            	dc.b	0
1239  00b1 ff            	dc.b	255
1240  00b2 00            	dc.b	0
1241  00b3 00            	dc.b	0
1242  00b4 00            	dc.b	0
1243  00b5 00            	dc.b	0
1244  00b6 00            	dc.b	0
1245  00b7 00            	dc.b	0
1246  00b8 00            	dc.b	0
1247  00b9 00            	dc.b	0
1248  00ba 0f            	dc.b	15
1249  00bb 08            	dc.b	8
1250  00bc 08            	dc.b	8
1251  00bd 0f            	dc.b	15
1252  00be 0f            	dc.b	15
1253  00bf 09            	dc.b	9
1254  00c0 09            	dc.b	9
1255  00c1 09            	dc.b	9
1256  00c2 09            	dc.b	9
1257  00c3 09            	dc.b	9
1258  00c4 09            	dc.b	9
1259  00c5 09            	dc.b	9
1260  00c6 f9            	dc.b	249
1261  00c7 01            	dc.b	1
1262  00c8 01            	dc.b	1
1263  00c9 ff            	dc.b	255
1264  00ca ff            	dc.b	255
1265  00cb 01            	dc.b	1
1266  00cc 01            	dc.b	1
1267  00cd f9            	dc.b	249
1268  00ce 09            	dc.b	9
1269  00cf 09            	dc.b	9
1270  00d0 09            	dc.b	9
1271  00d1 09            	dc.b	9
1272  00d2 09            	dc.b	9
1273  00d3 08            	dc.b	8
1274  00d4 08            	dc.b	8
1275  00d5 0f            	dc.b	15
1276  00d6 0f            	dc.b	15
1277  00d7 08            	dc.b	8
1278  00d8 08            	dc.b	8
1279  00d9 09            	dc.b	9
1280  00da 09            	dc.b	9
1281  00db 09            	dc.b	9
1282  00dc 09            	dc.b	9
1283  00dd 09            	dc.b	9
1284  00de 09            	dc.b	9
1285  00df 09            	dc.b	9
1286  00e0 09            	dc.b	9
1287  00e1 0f            	dc.b	15
1288  00e2 0f            	dc.b	15
1289  00e3 09            	dc.b	9
1290  00e4 09            	dc.b	9
1291  00e5 09            	dc.b	9
1292  00e6 09            	dc.b	9
1293  00e7 09            	dc.b	9
1294  00e8 09            	dc.b	9
1295  00e9 09            	dc.b	9
1296  00ea f9            	dc.b	249
1297  00eb 01            	dc.b	1
1298  00ec 01            	dc.b	1
1299  00ed ff            	dc.b	255
1300  00ee 0f            	dc.b	15
1301  00ef 09            	dc.b	9
1302  00f0 09            	dc.b	9
1303  00f1 09            	dc.b	9
1304  00f2 09            	dc.b	9
1305  00f3 09            	dc.b	9
1306  00f4 09            	dc.b	9
1307  00f5 09            	dc.b	9
1308  00f6 f9            	dc.b	249
1309  00f7 00            	dc.b	0
1310  00f8 00            	dc.b	0
1311  00f9 ff            	dc.b	255
1312  00fa 0f            	dc.b	15
1313  00fb 09            	dc.b	9
1314  00fc 09            	dc.b	9
1315  00fd 09            	dc.b	9
1316  00fe 09            	dc.b	9
1317  00ff 09            	dc.b	9
1318  0100 09            	dc.b	9
1319  0101 09            	dc.b	9
1320  0102 09            	dc.b	9
1321  0103 08            	dc.b	8
1322  0104 08            	dc.b	8
1323  0105 0f            	dc.b	15
1324  0106 ff            	dc.b	255
1325  0107 01            	dc.b	1
1326  0108 01            	dc.b	1
1327  0109 ff            	dc.b	255
1328  010a 00            	dc.b	0
1329  010b 00            	dc.b	0
1330  010c 00            	dc.b	0
1331  010d 00            	dc.b	0
1332  010e ff            	dc.b	255
1333  010f 01            	dc.b	1
1334  0110 01            	dc.b	1
1335  0111 ff            	dc.b	255
1336  0112 0f            	dc.b	15
1337  0113 08            	dc.b	8
1338  0114 08            	dc.b	8
1339  0115 09            	dc.b	9
1340  0116 09            	dc.b	9
1341  0117 09            	dc.b	9
1342  0118 09            	dc.b	9
1343  0119 09            	dc.b	9
1344  011a f9            	dc.b	249
1345  011b 00            	dc.b	0
1346  011c 00            	dc.b	0
1347  011d ff            	dc.b	255
1348  011e 00            	dc.b	0
1349  011f 00            	dc.b	0
1350  0120 00            	dc.b	0
1351  0121 00            	dc.b	0
1352  0122 00            	dc.b	0
1353  0123 00            	dc.b	0
1354  0124 00            	dc.b	0
1355  0125 00            	dc.b	0
1356  0126 0f            	dc.b	15
1357  0127 08            	dc.b	8
1358  0128 08            	dc.b	8
1359  0129 0f            	dc.b	15
1360  012a ff            	dc.b	255
1361  012b 01            	dc.b	1
1362  012c 01            	dc.b	1
1363  012d f9            	dc.b	249
1364  012e 09            	dc.b	9
1365  012f 09            	dc.b	9
1366  0130 09            	dc.b	9
1367  0131 09            	dc.b	9
1368  0132 09            	dc.b	9
1369  0133 09            	dc.b	9
1370  0134 09            	dc.b	9
1371  0135 0f            	dc.b	15
1372  0136 0f            	dc.b	15
1373  0137 08            	dc.b	8
1374  0138 08            	dc.b	8
1375  0139 09            	dc.b	9
1376  013a 09            	dc.b	9
1377  013b 09            	dc.b	9
1378  013c 09            	dc.b	9
1379  013d 09            	dc.b	9
1380  013e f9            	dc.b	249
1381  013f 01            	dc.b	1
1382  0140 01            	dc.b	1
1383  0141 ff            	dc.b	255
1384  0142 0f            	dc.b	15
1385  0143 09            	dc.b	9
1386  0144 09            	dc.b	9
1387  0145 09            	dc.b	9
1388  0146 09            	dc.b	9
1389  0147 09            	dc.b	9
1390  0148 09            	dc.b	9
1391  0149 09            	dc.b	9
1392  014a 09            	dc.b	9
1393  014b 08            	dc.b	8
1394  014c 08            	dc.b	8
1395  014d 0f            	dc.b	15
1396  014e ff            	dc.b	255
1397  014f 01            	dc.b	1
1398  0150 01            	dc.b	1
1399  0151 f9            	dc.b	249
1400  0152 09            	dc.b	9
1401  0153 09            	dc.b	9
1402  0154 09            	dc.b	9
1403  0155 09            	dc.b	9
1404  0156 09            	dc.b	9
1405  0157 09            	dc.b	9
1406  0158 09            	dc.b	9
1407  0159 0f            	dc.b	15
1408  015a ff            	dc.b	255
1409  015b 00            	dc.b	0
1410  015c 00            	dc.b	0
1411  015d f9            	dc.b	249
1412  015e 09            	dc.b	9
1413  015f 09            	dc.b	9
1414  0160 09            	dc.b	9
1415  0161 09            	dc.b	9
1416  0162 f9            	dc.b	249
1417  0163 01            	dc.b	1
1418  0164 01            	dc.b	1
1419  0165 ff            	dc.b	255
1420  0166 0f            	dc.b	15
1421  0167 08            	dc.b	8
1422  0168 08            	dc.b	8
1423  0169 09            	dc.b	9
1424  016a 09            	dc.b	9
1425  016b 09            	dc.b	9
1426  016c 09            	dc.b	9
1427  016d 09            	dc.b	9
1428  016e 09            	dc.b	9
1429  016f 08            	dc.b	8
1430  0170 08            	dc.b	8
1431  0171 0f            	dc.b	15
1432  0172 0f            	dc.b	15
1433  0173 09            	dc.b	9
1434  0174 09            	dc.b	9
1435  0175 09            	dc.b	9
1436  0176 09            	dc.b	9
1437  0177 09            	dc.b	9
1438  0178 09            	dc.b	9
1439  0179 09            	dc.b	9
1440  017a f9            	dc.b	249
1441  017b 01            	dc.b	1
1442  017c 01            	dc.b	1
1443  017d ff            	dc.b	255
1444  017e 00            	dc.b	0
1445  017f 00            	dc.b	0
1446  0180 00            	dc.b	0
1447  0181 00            	dc.b	0
1448  0182 00            	dc.b	0
1449  0183 00            	dc.b	0
1450  0184 00            	dc.b	0
1451  0185 00            	dc.b	0
1452  0186 ff            	dc.b	255
1453  0187 00            	dc.b	0
1454  0188 00            	dc.b	0
1455  0189 ff            	dc.b	255
1456  018a 00            	dc.b	0
1457  018b 00            	dc.b	0
1458  018c 00            	dc.b	0
1459  018d 00            	dc.b	0
1460  018e 00            	dc.b	0
1461  018f 00            	dc.b	0
1462  0190 00            	dc.b	0
1463  0191 00            	dc.b	0
1464  0192 0f            	dc.b	15
1465  0193 08            	dc.b	8
1466  0194 08            	dc.b	8
1467  0195 0f            	dc.b	15
1468  0196 ff            	dc.b	255
1469  0197 01            	dc.b	1
1470  0198 01            	dc.b	1
1471  0199 f9            	dc.b	249
1472  019a 09            	dc.b	9
1473  019b 09            	dc.b	9
1474  019c 09            	dc.b	9
1475  019d 09            	dc.b	9
1476  019e f9            	dc.b	249
1477  019f 01            	dc.b	1
1478  01a0 01            	dc.b	1
1479  01a1 ff            	dc.b	255
1480  01a2 ff            	dc.b	255
1481  01a3 00            	dc.b	0
1482  01a4 00            	dc.b	0
1483  01a5 f9            	dc.b	249
1484  01a6 09            	dc.b	9
1485  01a7 09            	dc.b	9
1486  01a8 09            	dc.b	9
1487  01a9 09            	dc.b	9
1488  01aa f9            	dc.b	249
1489  01ab 00            	dc.b	0
1490  01ac 00            	dc.b	0
1491  01ad ff            	dc.b	255
1492  01ae 0f            	dc.b	15
1493  01af 08            	dc.b	8
1494  01b0 08            	dc.b	8
1495  01b1 09            	dc.b	9
1496  01b2 09            	dc.b	9
1497  01b3 09            	dc.b	9
1498  01b4 09            	dc.b	9
1499  01b5 09            	dc.b	9
1500  01b6 09            	dc.b	9
1501  01b7 08            	dc.b	8
1502  01b8 08            	dc.b	8
1503  01b9 0f            	dc.b	15
1504  01ba ff            	dc.b	255
1505  01bb 01            	dc.b	1
1506  01bc 01            	dc.b	1
1507  01bd f9            	dc.b	249
1508  01be 09            	dc.b	9
1509  01bf 09            	dc.b	9
1510  01c0 09            	dc.b	9
1511  01c1 09            	dc.b	9
1512  01c2 f9            	dc.b	249
1513  01c3 01            	dc.b	1
1514  01c4 01            	dc.b	1
1515  01c5 ff            	dc.b	255
1516  01c6 0f            	dc.b	15
1517  01c7 08            	dc.b	8
1518  01c8 08            	dc.b	8
1519  01c9 09            	dc.b	9
1520  01ca 09            	dc.b	9
1521  01cb 09            	dc.b	9
1522  01cc 09            	dc.b	9
1523  01cd 09            	dc.b	9
1524  01ce f9            	dc.b	249
1525  01cf 00            	dc.b	0
1526  01d0 00            	dc.b	0
1527  01d1 ff            	dc.b	255
1528  01d2 0f            	dc.b	15
1529  01d3 09            	dc.b	9
1530  01d4 09            	dc.b	9
1531  01d5 09            	dc.b	9
1532  01d6 09            	dc.b	9
1533  01d7 09            	dc.b	9
1534  01d8 09            	dc.b	9
1535  01d9 09            	dc.b	9
1536  01da 09            	dc.b	9
1537  01db 08            	dc.b	8
1538  01dc 08            	dc.b	8
1539  01dd 0f            	dc.b	15
1603                     ; 86 void oled_print_giga_transparent_digit(char d, char x) {
1604                     	switch	.text
1605  01c7               _oled_print_giga_transparent_digit:
1607  01c7 89            	pushw	x
1608  01c8 52ff          	subw	sp,#255
1609  01ca 527a          	subw	sp,#122
1610       00000179      OFST:	set	377
1613                     ; 87 	char i=0;
1615                     ; 88   const char const_dig[10][36]={{0xff,0x01,0x01,0xf9,  0x09,0x09,0x09,0x09,  0xf9,0x01,0x01,0xff,  
1615                     ; 89 	                               0xff,0x00,0x00,0xff,  0x00,0x00,0x00,0x00,  0xff,0x00,0x00,0xff,
1615                     ; 90 																 0x0f,0x08,0x08,0x09,  0x09,0x09,0x09,0x09,  0x09,0x08,0x08,0x0f},  //0
1615                     ; 91 																 
1615                     ; 92                                 {0x00,0x00,0x00,0x00,  0x00,0x00,0x00,0x00,  0xff,0x01,0x01,0xff,  
1615                     ; 93 	                               0x00,0x00,0x00,0x00,  0x00,0x00,0x00,0x00,  0xff,0x00,0x00,0xff,
1615                     ; 94 																 0x00,0x00,0x00,0x00,  0x00,0x00,0x00,0x00,  0x0f,0x08,0x08,0x0f},  //1
1615                     ; 95 																 
1615                     ; 96                                 {0x0f,0x09,0x09,0x09,  0x09,0x09,0x09,0x09,  0xf9,0x01,0x01,0xff,  
1615                     ; 97 	                               0xff,0x01,0x01,0xf9,  0x09,0x09,0x09,0x09,  0x09,0x08,0x08,0x0f,
1615                     ; 98 																 0x0f,0x08,0x08,0x09,  0x09,0x09,0x09,0x09,  0x09,0x09,0x09,0x0f},  //2																 
1615                     ; 99 																 
1615                     ; 100                                 {0x0f,0x09,0x09,0x09,  0x09,0x09,0x09,0x09,  0xf9,0x01,0x01,0xff, 
1615                     ; 101 	                               0x0f,0x09,0x09,0x09,  0x09,0x09,0x09,0x09,  0xf9,0x00,0x00,0xff,
1615                     ; 102 																 0x0f,0x09,0x09,0x09,  0x09,0x09,0x09,0x09,  0x09,0x08,0x08,0x0f},  //3																 
1615                     ; 103 																 
1615                     ; 104                                 {0xff,0x01,0x01,0xff,  0x00,0x00,0x00,0x00,  0xff,0x01,0x01,0xff,  
1615                     ; 105 	                               0x0f,0x08,0x08,0x09,  0x09,0x09,0x09,0x09,  0xf9,0x00,0x00,0xff,
1615                     ; 106 																 0x00,0x00,0x00,0x00,  0x00,0x00,0x00,0x00,  0x0f,0x08,0x08,0x0f},  //4																 
1615                     ; 107 																 
1615                     ; 108 																{0xff,0x01,0x01,0xf9,  0x09,0x09,0x09,0x09,  0x09,0x09,0x09,0x0f,  
1615                     ; 109 	                               0x0f,0x08,0x08,0x09,  0x09,0x09,0x09,0x09,  0xf9,0x01,0x01,0xff,
1615                     ; 110 																 0x0f,0x09,0x09,0x09,  0x09,0x09,0x09,0x09,  0x09,0x08,0x08,0x0f},  //5		
1615                     ; 111 
1615                     ; 112                                 {0xff,0x01,0x01,0xf9,  0x09,0x09,0x09,0x09,  0x09,0x09,0x09,0x0f,  
1615                     ; 113 	                               0xff,0x00,0x00,0xf9,  0x09,0x09,0x09,0x09,  0xf9,0x01,0x01,0xff,
1615                     ; 114 																 0x0f,0x08,0x08,0x09,  0x09,0x09,0x09,0x09,  0x09,0x08,0x08,0x0f},  //6
1615                     ; 115 																 
1615                     ; 116                                 {0x0f,0x09,0x09,0x09,  0x09,0x09,0x09,0x09,  0xf9,0x01,0x01,0xff,  
1615                     ; 117 	                               0x00,0x00,0x00,0x00,  0x00,0x00,0x00,0x00,  0xff,0x00,0x00,0xff,
1615                     ; 118 																 0x00,0x00,0x00,0x00,  0x00,0x00,0x00,0x00,  0x0f,0x08,0x08,0x0f},  //7																 
1615                     ; 119 																 
1615                     ; 120                                 {0xff,0x01,0x01,0xf9,  0x09,0x09,0x09,0x09,  0xf9,0x01,0x01,0xff,  
1615                     ; 121 	                               0xff,0x00,0x00,0xf9,  0x09,0x09,0x09,0x09,  0xf9,0x00,0x00,0xff,
1615                     ; 122 																 0x0f,0x08,0x08,0x09,  0x09,0x09,0x09,0x09,  0x09,0x08,0x08,0x0f},  //8																 
1615                     ; 123 																 
1615                     ; 124                                 {0xff,0x01,0x01,0xf9,  0x09,0x09,0x09,0x09,  0xf9,0x01,0x01,0xff,  
1615                     ; 125 	                               0x0f,0x08,0x08,0x09,  0x09,0x09,0x09,0x09,  0xf9,0x00,0x00,0xff,
1615                     ; 126 																 0x0f,0x09,0x09,0x09,  0x09,0x09,0x09,0x09,  0x09,0x08,0x08,0x0f}}; //9				
1617  01cc 96            	ldw	x,sp
1618  01cd 1c0012        	addw	x,#OFST-359
1619  01d0 90ae0076      	ldw	y,#L314_const_dig
1620  01d4 bf00          	ldw	c_x,x
1621  01d6 ae0168        	ldw	x,#360
1622  01d9 cd0000        	call	c_xymovl
1624                     ; 128   set_cursor(x,0);
1626  01dc 96            	ldw	x,sp
1627  01dd 1c017b        	addw	x,#OFST+2
1628  01e0 f6            	ld	a,(x)
1629  01e1 5f            	clrw	x
1630  01e2 95            	ld	xh,a
1631  01e3 cd00d1        	call	_set_cursor
1633                     ; 129   i2c_wr_reg(oled_32_128_adr, 0x40, &const_dig[d][0],  12);
1635  01e6 4b0c          	push	#12
1636  01e8 96            	ldw	x,sp
1637  01e9 1c0013        	addw	x,#OFST-358
1638  01ec 1f10          	ldw	(OFST-361,sp),x
1640  01ee 96            	ldw	x,sp
1641  01ef 1c017b        	addw	x,#OFST+2
1642  01f2 f6            	ld	a,(x)
1643  01f3 97            	ld	xl,a
1644  01f4 a624          	ld	a,#36
1645  01f6 42            	mul	x,a
1646  01f7 72fb10        	addw	x,(OFST-361,sp)
1647  01fa 89            	pushw	x
1648  01fb ae3c40        	ldw	x,#15424
1649  01fe cd0000        	call	_i2c_wr_reg
1651  0201 5b03          	addw	sp,#3
1652                     ; 130   set_cursor(x,1);
1654  0203 96            	ldw	x,sp
1655  0204 1c017b        	addw	x,#OFST+2
1656  0207 f6            	ld	a,(x)
1657  0208 ae0001        	ldw	x,#1
1658  020b 95            	ld	xh,a
1659  020c cd00d1        	call	_set_cursor
1661                     ; 131   i2c_wr_reg(oled_32_128_adr, 0x40, &const_dig[d][12], 12);
1663  020f 4b0c          	push	#12
1664  0211 96            	ldw	x,sp
1665  0212 1c001f        	addw	x,#OFST-346
1666  0215 1f10          	ldw	(OFST-361,sp),x
1668  0217 96            	ldw	x,sp
1669  0218 1c017b        	addw	x,#OFST+2
1670  021b f6            	ld	a,(x)
1671  021c 97            	ld	xl,a
1672  021d a624          	ld	a,#36
1673  021f 42            	mul	x,a
1674  0220 72fb10        	addw	x,(OFST-361,sp)
1675  0223 89            	pushw	x
1676  0224 ae3c40        	ldw	x,#15424
1677  0227 cd0000        	call	_i2c_wr_reg
1679  022a 5b03          	addw	sp,#3
1680                     ; 132   set_cursor(x,2);
1682  022c 96            	ldw	x,sp
1683  022d 1c017b        	addw	x,#OFST+2
1684  0230 f6            	ld	a,(x)
1685  0231 ae0002        	ldw	x,#2
1686  0234 95            	ld	xh,a
1687  0235 cd00d1        	call	_set_cursor
1689                     ; 133   i2c_wr_reg(oled_32_128_adr, 0x40, &const_dig[d][24], 12);
1691  0238 4b0c          	push	#12
1692  023a 96            	ldw	x,sp
1693  023b 1c002b        	addw	x,#OFST-334
1694  023e 1f10          	ldw	(OFST-361,sp),x
1696  0240 96            	ldw	x,sp
1697  0241 1c017b        	addw	x,#OFST+2
1698  0244 f6            	ld	a,(x)
1699  0245 97            	ld	xl,a
1700  0246 a624          	ld	a,#36
1701  0248 42            	mul	x,a
1702  0249 72fb10        	addw	x,(OFST-361,sp)
1703  024c 89            	pushw	x
1704  024d ae3c40        	ldw	x,#15424
1705  0250 cd0000        	call	_i2c_wr_reg
1707  0253 5b03          	addw	sp,#3
1708                     ; 134 }
1711  0255 5bff          	addw	sp,#255
1712  0257 5b7c          	addw	sp,#124
1713  0259 81            	ret
1759                     ; 136 void oled_print_giga_space(char pos, char n) {
1760                     	switch	.text
1761  025a               _oled_print_giga_space:
1763  025a 89            	pushw	x
1764       00000000      OFST:	set	0
1767                     ; 137   set_cursor(pos,0 );send_repeat_data(0,n);
1769  025b 9e            	ld	a,xh
1770  025c 5f            	clrw	x
1771  025d 95            	ld	xh,a
1772  025e cd00d1        	call	_set_cursor
1776  0261 7b02          	ld	a,(OFST+2,sp)
1777  0263 5f            	clrw	x
1778  0264 97            	ld	xl,a
1779  0265 cd0081        	call	_send_repeat_data
1781                     ; 138   set_cursor(pos,1 );send_repeat_data(0,n);
1783  0268 7b01          	ld	a,(OFST+1,sp)
1784  026a ae0001        	ldw	x,#1
1785  026d 95            	ld	xh,a
1786  026e cd00d1        	call	_set_cursor
1790  0271 7b02          	ld	a,(OFST+2,sp)
1791  0273 5f            	clrw	x
1792  0274 97            	ld	xl,a
1793  0275 cd0081        	call	_send_repeat_data
1795                     ; 139   set_cursor(pos,2 );send_repeat_data(0,n);
1797  0278 7b01          	ld	a,(OFST+1,sp)
1798  027a ae0002        	ldw	x,#2
1799  027d 95            	ld	xh,a
1800  027e cd00d1        	call	_set_cursor
1804  0281 7b02          	ld	a,(OFST+2,sp)
1805  0283 5f            	clrw	x
1806  0284 97            	ld	xl,a
1807  0285 cd0081        	call	_send_repeat_data
1809                     ; 140   set_cursor(pos,3 );send_repeat_data(0,n);
1811  0288 7b01          	ld	a,(OFST+1,sp)
1812  028a ae0003        	ldw	x,#3
1813  028d 95            	ld	xh,a
1814  028e cd00d1        	call	_set_cursor
1818  0291 7b02          	ld	a,(OFST+2,sp)
1819  0293 5f            	clrw	x
1820  0294 97            	ld	xl,a
1821  0295 cd0081        	call	_send_repeat_data
1823                     ; 141 }
1826  0298 85            	popw	x
1827  0299 81            	ret
1830                     	switch	.const
1831  01de               L174_const_ch:
1832  01de 00            	dc.b	0
1833  01df 38            	dc.b	56
1834  01e0 38            	dc.b	56
1835  01e1 00            	dc.b	0
1836  01e2 00            	dc.b	0
1837  01e3 c0            	dc.b	192
1838  01e4 c0            	dc.b	192
1839  01e5 00            	dc.b	0
1840  01e6 00            	dc.b	0
1841  01e7 01            	dc.b	1
1842  01e8 01            	dc.b	1
1843  01e9 00            	dc.b	0
1844  01ea 00            	dc.b	0
1845  01eb 00            	dc.b	0
1846  01ec 00            	dc.b	0
1847  01ed 00            	dc.b	0
1848  01ee 06            	dc.b	6
1849  01ef 06            	dc.b	6
1850  01f0 06            	dc.b	6
1851  01f1 06            	dc.b	6
1852  01f2 00            	dc.b	0
1853  01f3 00            	dc.b	0
1854  01f4 00            	dc.b	0
1855  01f5 00            	dc.b	0
1856  01f6 00            	dc.b	0
1857  01f7 00            	dc.b	0
1858  01f8 00            	dc.b	0
1859  01f9 00            	dc.b	0
1860  01fa 00            	dc.b	0
1861  01fb 00            	dc.b	0
1862  01fc 00            	dc.b	0
1863  01fd 00            	dc.b	0
1864  01fe 00            	dc.b	0
1865  01ff 0e            	dc.b	14
1866  0200 00            	dc.b	0
1867  0201 00            	dc.b	0
1868  0202 fc            	dc.b	252
1869  0203 03            	dc.b	3
1870  0204 03            	dc.b	3
1871  0205 fc            	dc.b	252
1872  0206 ff            	dc.b	255
1873  0207 f0            	dc.b	240
1874  0208 f0            	dc.b	240
1875  0209 ff            	dc.b	255
1876  020a 0f            	dc.b	15
1877  020b 00            	dc.b	0
1878  020c 00            	dc.b	0
1879  020d 0f            	dc.b	15
1880  020e ff            	dc.b	255
1881  020f 00            	dc.b	0
1882  0210 00            	dc.b	0
1883  0211 ff            	dc.b	255
1884  0212 ff            	dc.b	255
1885  0213 00            	dc.b	0
1886  0214 00            	dc.b	0
1887  0215 ff            	dc.b	255
1888  0216 00            	dc.b	0
1889  0217 0f            	dc.b	15
1890  0218 0f            	dc.b	15
1891  0219 00            	dc.b	0
1892  021a ff            	dc.b	255
1893  021b 0f            	dc.b	15
1894  021c 0f            	dc.b	15
1895  021d 0f            	dc.b	15
1896  021e ff            	dc.b	255
1897  021f 0f            	dc.b	15
1898  0220 0f            	dc.b	15
1899  0221 0f            	dc.b	15
1900  0222 0f            	dc.b	15
1901  0223 0f            	dc.b	15
1902  0224 0f            	dc.b	15
1903  0225 0f            	dc.b	15
1995                     ; 142 char oled_print_giga_char(char c,char x)
1995                     ; 143 {
1996                     	switch	.text
1997  029a               _oled_print_giga_char:
1999  029a 89            	pushw	x
2000  029b 5259          	subw	sp,#89
2001       00000059      OFST:	set	89
2004                     ; 144   const char cc=3;
2006  029d a603          	ld	a,#3
2007  029f 6b4c          	ld	(OFST-13,sp),a
2009                     ; 146   const char const_ch[6][12]={{0x00,0x38,0x38,0x00, 0x00,0xc0,0xc0,0x00, 0x00,0x01,0x01,0x00},  //0   ':'
2009                     ; 147                               {0x00,0x00,0x00,0x00, 0x06,0x06,0x06,0x06, 0x00,0x00,0x00,0x00},  //1   '-'
2009                     ; 148                               {0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x00,0x0e,0x00,0x00},  //2   '.'
2009                     ; 149 															{0xfc,0x03,0x03,0xfc, 0xff,0xf0,0xf0,0xff, 0x0f,0x00,0x00,0x0f},  //3   'A'
2009                     ; 150 															{0xff,0x00,0x00,0xff, 0xff,0x00,0x00,0xff, 0x00,0x0f,0x0f,0x00},  //4   'V'
2009                     ; 151 															{0xff,0x0f,0x0f,0x0f, 0xff,0x0f,0x0f,0x0f, 0x0f,0x0f,0x0f,0x0f}   //4   'E'
2009                     ; 152                               }; 
2011  02a1 96            	ldw	x,sp
2012  02a2 1c0003        	addw	x,#OFST-86
2013  02a5 90ae01de      	ldw	y,#L174_const_ch
2014  02a9 a648          	ld	a,#72
2015  02ab cd0000        	call	c_xymov
2017                     ; 157   switch(c)
2019  02ae 7b5a          	ld	a,(OFST+1,sp)
2021                     ; 164 	case 'E':{c=5; pos=16; break;}
2022  02b0 a02d          	sub	a,#45
2023  02b2 271d          	jreq	L574
2024  02b4 4a            	dec	a
2025  02b5 2724          	jreq	L774
2026  02b7 a00c          	sub	a,#12
2027  02b9 270e          	jreq	L374
2028  02bb a007          	sub	a,#7
2029  02bd 2726          	jreq	L105
2030  02bf a004          	sub	a,#4
2031  02c1 2736          	jreq	L505
2032  02c3 a011          	sub	a,#17
2033  02c5 2728          	jreq	L305
2034  02c7 2038          	jra	L755
2035  02c9               L374:
2036                     ; 159   case ':':{c=0; pos=16; break;}
2038  02c9 0f5a          	clr	(OFST+1,sp)
2041  02cb a610          	ld	a,#16
2042  02cd 6b4b          	ld	(OFST-14,sp),a
2046  02cf 2030          	jra	L755
2047  02d1               L574:
2048                     ; 160   case '-':{c=1; pos=16; break;}
2050  02d1 a601          	ld	a,#1
2051  02d3 6b5a          	ld	(OFST+1,sp),a
2054  02d5 a610          	ld	a,#16
2055  02d7 6b4b          	ld	(OFST-14,sp),a
2059  02d9 2026          	jra	L755
2060  02db               L774:
2061                     ; 161   case '.':{c=2; pos=12; break;}
2063  02db a602          	ld	a,#2
2064  02dd 6b5a          	ld	(OFST+1,sp),a
2067  02df a60c          	ld	a,#12
2068  02e1 6b4b          	ld	(OFST-14,sp),a
2072  02e3 201c          	jra	L755
2073  02e5               L105:
2074                     ; 162 	case 'A':{c=3; pos=16; break;}
2076  02e5 a603          	ld	a,#3
2077  02e7 6b5a          	ld	(OFST+1,sp),a
2080  02e9 a610          	ld	a,#16
2081  02eb 6b4b          	ld	(OFST-14,sp),a
2085  02ed 2012          	jra	L755
2086  02ef               L305:
2087                     ; 163 	case 'V':{c=4; pos=16; break;}
2089  02ef a604          	ld	a,#4
2090  02f1 6b5a          	ld	(OFST+1,sp),a
2093  02f3 a610          	ld	a,#16
2094  02f5 6b4b          	ld	(OFST-14,sp),a
2098  02f7 2008          	jra	L755
2099  02f9               L505:
2100                     ; 164 	case 'E':{c=5; pos=16; break;}
2102  02f9 a605          	ld	a,#5
2103  02fb 6b5a          	ld	(OFST+1,sp),a
2106  02fd a610          	ld	a,#16
2107  02ff 6b4b          	ld	(OFST-14,sp),a
2111  0301               L755:
2112                     ; 168   for (i=0;i<12;i++) ch[i]=const_ch[c][i]; 
2114  0301 0f59          	clr	(OFST+0,sp)
2116  0303               L165:
2119  0303 96            	ldw	x,sp
2120  0304 1c004d        	addw	x,#OFST-12
2121  0307 9f            	ld	a,xl
2122  0308 5e            	swapw	x
2123  0309 1b59          	add	a,(OFST+0,sp)
2124  030b 2401          	jrnc	L65
2125  030d 5c            	incw	x
2126  030e               L65:
2127  030e 02            	rlwa	x,a
2128  030f 89            	pushw	x
2129  0310 96            	ldw	x,sp
2130  0311 1c0005        	addw	x,#OFST-84
2131  0314 1f03          	ldw	(OFST-86,sp),x
2133  0316 7b5c          	ld	a,(OFST+3,sp)
2134  0318 97            	ld	xl,a
2135  0319 a60c          	ld	a,#12
2136  031b 42            	mul	x,a
2137  031c 72fb03        	addw	x,(OFST-86,sp)
2138  031f 01            	rrwa	x,a
2139  0320 1b5b          	add	a,(OFST+2,sp)
2140  0322 2401          	jrnc	L06
2141  0324 5c            	incw	x
2142  0325               L06:
2143  0325 02            	rlwa	x,a
2144  0326 f6            	ld	a,(x)
2145  0327 85            	popw	x
2146  0328 f7            	ld	(x),a
2149  0329 0c59          	inc	(OFST+0,sp)
2153  032b 7b59          	ld	a,(OFST+0,sp)
2154  032d a10c          	cp	a,#12
2155  032f 25d2          	jrult	L165
2156                     ; 170   set_cursor(x,0);
2158  0331 7b5b          	ld	a,(OFST+2,sp)
2159  0333 5f            	clrw	x
2160  0334 95            	ld	xh,a
2161  0335 cd00d1        	call	_set_cursor
2163                     ; 171 	set_cursor(x,0);
2165  0338 7b5b          	ld	a,(OFST+2,sp)
2166  033a 5f            	clrw	x
2167  033b 95            	ld	xh,a
2168  033c cd00d1        	call	_set_cursor
2170                     ; 172   for (i=0;i<4;i++) send_repeat_data(ch[i],cc);
2172  033f 0f59          	clr	(OFST+0,sp)
2174  0341               L765:
2177  0341 7b4c          	ld	a,(OFST-13,sp)
2178  0343 97            	ld	xl,a
2179  0344 89            	pushw	x
2180  0345 96            	ldw	x,sp
2181  0346 1c004f        	addw	x,#OFST-10
2182  0349 9f            	ld	a,xl
2183  034a 5e            	swapw	x
2184  034b 1b5b          	add	a,(OFST+2,sp)
2185  034d 2401          	jrnc	L26
2186  034f 5c            	incw	x
2187  0350               L26:
2188  0350 02            	rlwa	x,a
2189  0351 f6            	ld	a,(x)
2190  0352 85            	popw	x
2191  0353 95            	ld	xh,a
2192  0354 cd0081        	call	_send_repeat_data
2196  0357 0c59          	inc	(OFST+0,sp)
2200  0359 7b59          	ld	a,(OFST+0,sp)
2201  035b a104          	cp	a,#4
2202  035d 25e2          	jrult	L765
2203                     ; 173   set_cursor(x,1);
2205  035f 7b5b          	ld	a,(OFST+2,sp)
2206  0361 ae0001        	ldw	x,#1
2207  0364 95            	ld	xh,a
2208  0365 cd00d1        	call	_set_cursor
2210                     ; 174   for (i=4;i<8;i++) send_repeat_data(ch[i],cc);
2212  0368 a604          	ld	a,#4
2213  036a 6b59          	ld	(OFST+0,sp),a
2215  036c               L575:
2218  036c 7b4c          	ld	a,(OFST-13,sp)
2219  036e 97            	ld	xl,a
2220  036f 89            	pushw	x
2221  0370 96            	ldw	x,sp
2222  0371 1c004f        	addw	x,#OFST-10
2223  0374 9f            	ld	a,xl
2224  0375 5e            	swapw	x
2225  0376 1b5b          	add	a,(OFST+2,sp)
2226  0378 2401          	jrnc	L46
2227  037a 5c            	incw	x
2228  037b               L46:
2229  037b 02            	rlwa	x,a
2230  037c f6            	ld	a,(x)
2231  037d 85            	popw	x
2232  037e 95            	ld	xh,a
2233  037f cd0081        	call	_send_repeat_data
2237  0382 0c59          	inc	(OFST+0,sp)
2241  0384 7b59          	ld	a,(OFST+0,sp)
2242  0386 a108          	cp	a,#8
2243  0388 25e2          	jrult	L575
2244                     ; 175   set_cursor(x,2);
2246  038a 7b5b          	ld	a,(OFST+2,sp)
2247  038c ae0002        	ldw	x,#2
2248  038f 95            	ld	xh,a
2249  0390 cd00d1        	call	_set_cursor
2251                     ; 176   for (i=8;i<12;i++) send_repeat_data(ch[i],cc);
2253  0393 a608          	ld	a,#8
2254  0395 6b59          	ld	(OFST+0,sp),a
2256  0397               L306:
2259  0397 7b4c          	ld	a,(OFST-13,sp)
2260  0399 97            	ld	xl,a
2261  039a 89            	pushw	x
2262  039b 96            	ldw	x,sp
2263  039c 1c004f        	addw	x,#OFST-10
2264  039f 9f            	ld	a,xl
2265  03a0 5e            	swapw	x
2266  03a1 1b5b          	add	a,(OFST+2,sp)
2267  03a3 2401          	jrnc	L66
2268  03a5 5c            	incw	x
2269  03a6               L66:
2270  03a6 02            	rlwa	x,a
2271  03a7 f6            	ld	a,(x)
2272  03a8 85            	popw	x
2273  03a9 95            	ld	xh,a
2274  03aa cd0081        	call	_send_repeat_data
2278  03ad 0c59          	inc	(OFST+0,sp)
2282  03af 7b59          	ld	a,(OFST+0,sp)
2283  03b1 a10c          	cp	a,#12
2284  03b3 25e2          	jrult	L306
2285                     ; 177   return (pos+x);
2287  03b5 7b4b          	ld	a,(OFST-14,sp)
2288  03b7 1b5b          	add	a,(OFST+2,sp)
2291  03b9 5b5b          	addw	sp,#91
2292  03bb 81            	ret
2295                     	xref.b	_oledBuffer
2376                     ; 180 void oled_print_XXnumber(int n, char pos, char transparent) {
2377                     	switch	.text
2378  03bc               _oled_print_XXnumber:
2380  03bc 89            	pushw	x
2381  03bd 5203          	subw	sp,#3
2382       00000003      OFST:	set	3
2385                     ; 183   char space=0;
2387  03bf 0f01          	clr	(OFST-2,sp)
2389                     ; 184 	char bufIndex = 0;
2391  03c1 0f02          	clr	(OFST-1,sp)
2393                     ; 187   for (i=0; i<DIG_BUF_SIZE; i++) {if (n == oledBuffer.value[i] && pos == oledBuffer.position[i] && transparent == oledBuffer.transperent_view[i]) return;}
2395  03c3 0f03          	clr	(OFST+0,sp)
2397  03c5               L356:
2400  03c5 7b03          	ld	a,(OFST+0,sp)
2401  03c7 5f            	clrw	x
2402  03c8 97            	ld	xl,a
2403  03c9 58            	sllw	x
2404  03ca 9093          	ldw	y,x
2405  03cc 51            	exgw	x,y
2406  03cd ee01          	ldw	x,(_oledBuffer+1,x)
2407  03cf 1304          	cpw	x,(OFST+1,sp)
2408  03d1 51            	exgw	x,y
2409  03d2 2617          	jrne	L166
2411  03d4 7b03          	ld	a,(OFST+0,sp)
2412  03d6 5f            	clrw	x
2413  03d7 97            	ld	xl,a
2414  03d8 e610          	ld	a,(_oledBuffer+16,x)
2415  03da 1108          	cp	a,(OFST+5,sp)
2416  03dc 260d          	jrne	L166
2418  03de 7b03          	ld	a,(OFST+0,sp)
2419  03e0 5f            	clrw	x
2420  03e1 97            	ld	xl,a
2421  03e2 e60b          	ld	a,(_oledBuffer+11,x)
2422  03e4 1109          	cp	a,(OFST+6,sp)
2423  03e6 2603          	jrne	L47
2424  03e8 cc04ba        	jp	L27
2425  03eb               L47:
2428  03eb               L166:
2431  03eb 0c03          	inc	(OFST+0,sp)
2435  03ed 7b03          	ld	a,(OFST+0,sp)
2436  03ef a105          	cp	a,#5
2437  03f1 25d2          	jrult	L356
2438                     ; 190   for (i=0; i<DIG_BUF_SIZE; i++) {if (n >= 0 && oledBuffer.value[i]<0 && pos == oledBuffer.position[i]) space=1;}  
2440  03f3 0f03          	clr	(OFST+0,sp)
2442  03f5               L366:
2445  03f5 9c            	rvf
2446  03f6 1e04          	ldw	x,(OFST+1,sp)
2447  03f8 2f18          	jrslt	L176
2449  03fa 9c            	rvf
2450  03fb 7b03          	ld	a,(OFST+0,sp)
2451  03fd 5f            	clrw	x
2452  03fe 97            	ld	xl,a
2453  03ff 58            	sllw	x
2454  0400 6d01          	tnz	(_oledBuffer+1,x)
2455  0402 2e0e          	jrsge	L176
2457  0404 7b03          	ld	a,(OFST+0,sp)
2458  0406 5f            	clrw	x
2459  0407 97            	ld	xl,a
2460  0408 e610          	ld	a,(_oledBuffer+16,x)
2461  040a 1108          	cp	a,(OFST+5,sp)
2462  040c 2604          	jrne	L176
2465  040e a601          	ld	a,#1
2466  0410 6b01          	ld	(OFST-2,sp),a
2468  0412               L176:
2471  0412 0c03          	inc	(OFST+0,sp)
2475  0414 7b03          	ld	a,(OFST+0,sp)
2476  0416 a105          	cp	a,#5
2477  0418 25db          	jrult	L366
2479  041a 2002          	jra	L576
2480  041c               L376:
2481                     ; 193   {bufIndex++;}
2483  041c 0c02          	inc	(OFST-1,sp)
2485  041e               L576:
2486                     ; 192   while(oledBuffer.position[bufIndex] != 255  && oledBuffer.position[bufIndex] != pos)
2488  041e 7b02          	ld	a,(OFST-1,sp)
2489  0420 5f            	clrw	x
2490  0421 97            	ld	xl,a
2491  0422 e610          	ld	a,(_oledBuffer+16,x)
2492  0424 a1ff          	cp	a,#255
2493  0426 270a          	jreq	L107
2495  0428 7b02          	ld	a,(OFST-1,sp)
2496  042a 5f            	clrw	x
2497  042b 97            	ld	xl,a
2498  042c e610          	ld	a,(_oledBuffer+16,x)
2499  042e 1108          	cp	a,(OFST+5,sp)
2500  0430 26ea          	jrne	L376
2501  0432               L107:
2502                     ; 194   oledBuffer.position[bufIndex] = pos;
2504  0432 7b02          	ld	a,(OFST-1,sp)
2505  0434 5f            	clrw	x
2506  0435 97            	ld	xl,a
2507  0436 7b08          	ld	a,(OFST+5,sp)
2508  0438 e710          	ld	(_oledBuffer+16,x),a
2509                     ; 195   oledBuffer.value[bufIndex] = n;
2511  043a 7b02          	ld	a,(OFST-1,sp)
2512  043c 5f            	clrw	x
2513  043d 97            	ld	xl,a
2514  043e 58            	sllw	x
2515  043f 1604          	ldw	y,(OFST+1,sp)
2516  0441 ef01          	ldw	(_oledBuffer+1,x),y
2517                     ; 196   oledBuffer.transperent_view[bufIndex] = transparent;
2519  0443 7b02          	ld	a,(OFST-1,sp)
2520  0445 5f            	clrw	x
2521  0446 97            	ld	xl,a
2522  0447 7b09          	ld	a,(OFST+6,sp)
2523  0449 e70b          	ld	(_oledBuffer+11,x),a
2524                     ; 198   if (n<0) {oled_print_giga_char('-',pos);pos+=16;n=-n;} 
2526  044b 9c            	rvf
2527  044c 1e04          	ldw	x,(OFST+1,sp)
2528  044e 2e14          	jrsge	L307
2531  0450 7b08          	ld	a,(OFST+5,sp)
2532  0452 ae2d00        	ldw	x,#11520
2533  0455 97            	ld	xl,a
2534  0456 cd029a        	call	_oled_print_giga_char
2538  0459 7b08          	ld	a,(OFST+5,sp)
2539  045b ab10          	add	a,#16
2540  045d 6b08          	ld	(OFST+5,sp),a
2543  045f 1e04          	ldw	x,(OFST+1,sp)
2544  0461 50            	negw	x
2545  0462 1f04          	ldw	(OFST+1,sp),x
2546  0464               L307:
2547                     ; 199   if (n >= 10) {oled_print_giga_digit(n/10, pos, transparent);}
2549  0464 9c            	rvf
2550  0465 1e04          	ldw	x,(OFST+1,sp)
2551  0467 a3000a        	cpw	x,#10
2552  046a 2f16          	jrslt	L507
2555  046c 7b09          	ld	a,(OFST+6,sp)
2556  046e 88            	push	a
2557  046f 7b09          	ld	a,(OFST+6,sp)
2558  0471 97            	ld	xl,a
2559  0472 1605          	ldw	y,(OFST+2,sp)
2560  0474 a60a          	ld	a,#10
2561  0476 cd0000        	call	c_sdivy
2563  0479 909f          	ld	a,yl
2564  047b 95            	ld	xh,a
2565  047c cd00eb        	call	_oled_print_giga_digit
2567  047f 84            	pop	a
2569  0480 200b          	jra	L707
2570  0482               L507:
2571                     ; 200   else {oled_print_giga_digit(0, pos, transparent);}
2573  0482 7b09          	ld	a,(OFST+6,sp)
2574  0484 88            	push	a
2575  0485 7b09          	ld	a,(OFST+6,sp)
2576  0487 5f            	clrw	x
2577  0488 97            	ld	xl,a
2578  0489 cd00eb        	call	_oled_print_giga_digit
2580  048c 84            	pop	a
2581  048d               L707:
2582                     ; 201   pos += 16;
2584  048d 7b08          	ld	a,(OFST+5,sp)
2585  048f ab10          	add	a,#16
2586  0491 6b08          	ld	(OFST+5,sp),a
2587                     ; 202   oled_print_giga_digit(n%10, pos, transparent);
2589  0493 7b09          	ld	a,(OFST+6,sp)
2590  0495 88            	push	a
2591  0496 7b09          	ld	a,(OFST+6,sp)
2592  0498 97            	ld	xl,a
2593  0499 1605          	ldw	y,(OFST+2,sp)
2594  049b a60a          	ld	a,#10
2595  049d cd0000        	call	c_smody
2597  04a0 909f          	ld	a,yl
2598  04a2 95            	ld	xh,a
2599  04a3 cd00eb        	call	_oled_print_giga_digit
2601  04a6 84            	pop	a
2602                     ; 203   if(space){pos += 16; oled_print_giga_space(pos, 16);}
2604  04a7 0d01          	tnz	(OFST-2,sp)
2605  04a9 270f          	jreq	L117
2608  04ab 7b08          	ld	a,(OFST+5,sp)
2609  04ad ab10          	add	a,#16
2610  04af 6b08          	ld	(OFST+5,sp),a
2613  04b1 7b08          	ld	a,(OFST+5,sp)
2614  04b3 ae0010        	ldw	x,#16
2615  04b6 95            	ld	xh,a
2616  04b7 cd025a        	call	_oled_print_giga_space
2618  04ba               L117:
2619                     ; 204 }
2620  04ba               L27:
2623  04ba 5b05          	addw	sp,#5
2624  04bc 81            	ret
2627                     	xref.b	_transferBody
2650                     ; 206 void print_time(void) { 
2651                     	switch	.text
2652  04bd               _print_time:
2656                     ; 208       oled_print_giga_char(':', 81);
2658  04bd ae3a51        	ldw	x,#14929
2659  04c0 cd029a        	call	_oled_print_giga_char
2661                     ; 209 			oled_print_giga_char(':', 35);
2663  04c3 ae3a23        	ldw	x,#14883
2664  04c6 cd029a        	call	_oled_print_giga_char
2666                     ; 210       oled_print_XXnumber(transferBody.sec, 96, 0); 
2668  04c9 4b00          	push	#0
2669  04cb 4b60          	push	#96
2670  04cd b605          	ld	a,_transferBody+5
2671  04cf 5f            	clrw	x
2672  04d0 97            	ld	xl,a
2673  04d1 cd03bc        	call	_oled_print_XXnumber
2675  04d4 85            	popw	x
2676                     ; 211       oled_print_XXnumber(transferBody.min, 50, 0); 
2678  04d5 4b00          	push	#0
2679  04d7 4b32          	push	#50
2680  04d9 b604          	ld	a,_transferBody+4
2681  04db 5f            	clrw	x
2682  04dc 97            	ld	xl,a
2683  04dd cd03bc        	call	_oled_print_XXnumber
2685  04e0 85            	popw	x
2686                     ; 212       oled_print_XXnumber(transferBody.hr , 4, 0); 
2688  04e1 4b00          	push	#0
2689  04e3 4b04          	push	#4
2690  04e5 b603          	ld	a,_transferBody+3
2691  04e7 5f            	clrw	x
2692  04e8 97            	ld	xl,a
2693  04e9 cd03bc        	call	_oled_print_XXnumber
2695  04ec 85            	popw	x
2696                     ; 213 }
2699  04ed 81            	ret
2736                     ; 215 void print_save(void) { 
2737                     	switch	.text
2738  04ee               _print_save:
2740  04ee 88            	push	a
2741       00000001      OFST:	set	1
2744                     ; 217   oled_Clear_Screen();   
2746  04ef cd005f        	call	_oled_Clear_Screen
2748                     ; 218 	for(i=0;i<10;i++){
2750  04f2 0f01          	clr	(OFST+0,sp)
2752  04f4               L147:
2753                     ; 219 	  oled_print_giga_digit(5,0,0);
2755  04f4 4b00          	push	#0
2756  04f6 ae0500        	ldw	x,#1280
2757  04f9 cd00eb        	call	_oled_print_giga_digit
2759  04fc 84            	pop	a
2760                     ; 220     oled_print_giga_char('A',16);
2762  04fd ae4110        	ldw	x,#16656
2763  0500 cd029a        	call	_oled_print_giga_char
2765                     ; 221 	  oled_print_giga_char('V',32);
2767  0503 ae5620        	ldw	x,#22048
2768  0506 cd029a        	call	_oled_print_giga_char
2770                     ; 222 	  oled_print_giga_char('E',48);	
2772  0509 ae4530        	ldw	x,#17712
2773  050c cd029a        	call	_oled_print_giga_char
2775                     ; 218 	for(i=0;i<10;i++){
2777  050f 0c01          	inc	(OFST+0,sp)
2781  0511 7b01          	ld	a,(OFST+0,sp)
2782  0513 a10a          	cp	a,#10
2783  0515 25dd          	jrult	L147
2784                     ; 224 	oled_Clear_Screen();
2786  0517 cd005f        	call	_oled_Clear_Screen
2788                     ; 225 }
2791  051a 84            	pop	a
2792  051b 81            	ret
2805                     	xdef	_print_save
2806                     	xdef	_print_time
2807                     	xdef	_oled_print_XXnumber
2808                     	xdef	_oled_print_giga_char
2809                     	xdef	_oled_print_giga_solid_digit
2810                     	xdef	_oled_print_giga_transparent_digit
2811                     	xdef	_oled_print_giga_digit
2812                     	xdef	_send_repeat_data
2813                     	xdef	_ff_string
2814                     	xdef	_set_cursor
2815                     	xdef	_oled_print_giga_space
2816                     	xdef	_oled_Clear_Screen
2817                     	xdef	_blankScreen
2818                     	xdef	_sendData
2819                     	xdef	_sendCmd
2820                     	xdef	_set_brightness_ssd1306
2821                     	xdef	_init_ssd1306
2822                     	xref	_i2c_wr_reg
2823                     	xref.b	c_x
2824                     	xref.b	c_y
2843                     	xref	c_smody
2844                     	xref	c_sdivy
2845                     	xref	c_xymovl
2846                     	xref	c_xymov
2847                     	end
