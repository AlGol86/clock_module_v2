   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.5 - 16 Jun 2021
   3                     ; Generator (Limited) V4.5.3 - 16 Jun 2021
  64                     ; 6 void delay_rtc(char del) {
  66                     	switch	.text
  67  0000               _delay_rtc:
  69  0000 88            	push	a
  70  0001 88            	push	a
  71       00000001      OFST:	set	1
  74                     ; 8   for(i=0;i<(del);i++) {nop();}
  76  0002 0f01          	clr	(OFST+0,sp)
  79  0004 2003          	jra	L73
  80  0006               L33:
  84  0006 9d            nop
  89  0007 0c01          	inc	(OFST+0,sp)
  91  0009               L73:
  94  0009 7b01          	ld	a,(OFST+0,sp)
  95  000b 1102          	cp	a,(OFST+1,sp)
  96  000d 25f7          	jrult	L33
  97                     ; 9 }
 100  000f 85            	popw	x
 101  0010 81            	ret
 124                     ; 11 void init_rtc(void) {
 125                     	switch	.text
 126  0011               _init_rtc:
 130                     ; 12   GPIOC->CR2&=~BIT_clk_rtc ; // low speed (interrupt disabled)
 132  0011 721b500e      	bres	20494,#5
 133                     ; 13   GPIOA->CR2&=~BIT_rst_rtc ; // low speed (interrupt disabled)
 135  0015 72175004      	bres	20484,#3
 136                     ; 14   GPIOC->CR1|=BIT_clk_rtc ; // p-p 
 138  0019 721a500d      	bset	20493,#5
 139                     ; 15   GPIOA->CR1|=BIT_rst_rtc ; // p-p 
 141  001d 72165003      	bset	20483,#3
 142                     ; 16   GPIOC->ODR&=~BIT_clk_rtc ;  //clk_pin, rst_pin  - 0 
 144  0021 721b500a      	bres	20490,#5
 145                     ; 17   GPIOA->ODR&=~BIT_rst_rtc ;  //clk_pin, rst_pin  - 0 
 147  0025 72175000      	bres	20480,#3
 148                     ; 18   GPIOC->DDR|=BIT_clk_rtc ; 
 150  0029 721a500c      	bset	20492,#5
 151                     ; 19   GPIOA->DDR|=BIT_rst_rtc ; 
 153  002d 72165002      	bset	20482,#3
 154                     ; 21   GPIOC->CR2&=~BIT_dat_rtc; //dat_pin  - low speed (interrupt disabled)
 156  0031 7219500e      	bres	20494,#4
 157                     ; 22   GPIOC->CR1|=BIT_dat_rtc; //dat_pin - p-p /float in inp. direct
 159  0035 7218500d      	bset	20493,#4
 160                     ; 23   GPIOC->ODR&=~BIT_dat_rtc;  //dat_pin  - 1 (SDA)
 162  0039 7219500a      	bres	20490,#4
 163                     ; 24   GPIOC->DDR|=BIT_dat_rtc; 
 165  003d 7218500c      	bset	20492,#4
 166                     ; 25  }
 169  0041 81            	ret
 271                     ; 27 void rtc_set_time_date(LocalTime time, LocalDate date) {
 272                     	switch	.text
 273  0042               _rtc_set_time_date:
 275       00000000      OFST:	set	0
 278                     ; 28   send_rtc(CONTR,0);  //WRITE-PROTECT: OFF
 280  0042 ae0700        	ldw	x,#1792
 281  0045 cd00f7        	call	_send_rtc
 283                     ; 29   send_rtc(TR_CH,0);    //TRICKLE CHARGER: OFF
 285  0048 ae0800        	ldw	x,#2048
 286  004b cd00f7        	call	_send_rtc
 288                     ; 30   send_rtc(YEAR, date.year % 100); 
 290  004e 1e06          	ldw	x,(OFST+6,sp)
 291  0050 a664          	ld	a,#100
 292  0052 cd0000        	call	c_smodx
 294  0055 9f            	ld	a,xl
 295  0056 ae0600        	ldw	x,#1536
 296  0059 97            	ld	xl,a
 297  005a cd00f7        	call	_send_rtc
 299                     ; 32   send_rtc(MONTH, date.month); 
 301  005d 7b08          	ld	a,(OFST+8,sp)
 302  005f ae0400        	ldw	x,#1024
 303  0062 97            	ld	xl,a
 304  0063 cd00f7        	call	_send_rtc
 306                     ; 33   send_rtc(DATE, date.dayOfMonth); 
 308  0066 7b09          	ld	a,(OFST+9,sp)
 309  0068 ae0300        	ldw	x,#768
 310  006b 97            	ld	xl,a
 311  006c cd00f7        	call	_send_rtc
 313                     ; 34   send_rtc(HR, time.hr); 
 315  006f 7b03          	ld	a,(OFST+3,sp)
 316  0071 ae0200        	ldw	x,#512
 317  0074 97            	ld	xl,a
 318  0075 cd00f7        	call	_send_rtc
 320                     ; 35   send_rtc(MIN, time.min); 
 322  0078 7b04          	ld	a,(OFST+4,sp)
 323  007a ae0100        	ldw	x,#256
 324  007d 97            	ld	xl,a
 325  007e ad77          	call	_send_rtc
 327                     ; 36   send_rtc(SEC, 0);
 329  0080 5f            	clrw	x
 330  0081 ad74          	call	_send_rtc
 332                     ; 37 }
 335  0083 81            	ret
 379                     ; 39 void send_byte_rtc(char data) {
 380                     	switch	.text
 381  0084               _send_byte_rtc:
 383  0084 88            	push	a
 384  0085 88            	push	a
 385       00000001      OFST:	set	1
 388                     ; 41   for(i=1;i<=8;i++) {
 390  0086 a601          	ld	a,#1
 391  0088 6b01          	ld	(OFST+0,sp),a
 393  008a               L341:
 394                     ; 42     GPIOC->ODR|=(data&1)<<PIN_dat_rtc;
 396  008a 7b02          	ld	a,(OFST+1,sp)
 397  008c a401          	and	a,#1
 398  008e 97            	ld	xl,a
 399  008f a610          	ld	a,#16
 400  0091 42            	mul	x,a
 401  0092 9f            	ld	a,xl
 402  0093 ca500a        	or	a,20490
 403  0096 c7500a        	ld	20490,a
 404                     ; 43     data>>=1;
 406  0099 0402          	srl	(OFST+1,sp)
 407                     ; 44     GPIOC->ODR|=BIT_clk_rtc; // clk=1
 409  009b 721a500a      	bset	20490,#5
 410                     ; 45     nop();
 413  009f 9d            nop
 415                     ; 46     GPIOC->ODR&=~BIT_dat_rtc; // sda=1
 418  00a0 7219500a      	bres	20490,#4
 419                     ; 47     GPIOC->ODR&=~BIT_clk_rtc;// clk=0
 421  00a4 721b500a      	bres	20490,#5
 422                     ; 41   for(i=1;i<=8;i++) {
 424  00a8 0c01          	inc	(OFST+0,sp)
 428  00aa 7b01          	ld	a,(OFST+0,sp)
 429  00ac a109          	cp	a,#9
 430  00ae 25da          	jrult	L341
 431                     ; 49 }
 434  00b0 85            	popw	x
 435  00b1 81            	ret
 483                     ; 51 char  receive_byte_rtc(void) {
 484                     	switch	.text
 485  00b2               _receive_byte_rtc:
 487  00b2 89            	pushw	x
 488       00000002      OFST:	set	2
 491                     ; 52   char data=0;
 493  00b3 0f01          	clr	(OFST-1,sp)
 495                     ; 54   GPIOC->CR1|=BIT_dat_rtc;
 497  00b5 7218500d      	bset	20493,#4
 498                     ; 55   nop();
 501  00b9 9d            nop
 503                     ; 56   GPIOC->DDR&=~BIT_dat_rtc;
 506  00ba 7219500c      	bres	20492,#4
 507                     ; 57   for(i=0;i<=7;i++) {
 509  00be 0f02          	clr	(OFST+0,sp)
 511  00c0               L371:
 512                     ; 58     nop();
 515  00c0 9d            nop
 517                     ; 59     GPIOC->ODR|=BIT_clk_rtc; // clk=1
 520  00c1 721a500a      	bset	20490,#5
 521                     ; 60     nop();
 524  00c5 9d            nop
 526                     ; 61     data|=((GPIOC->IDR&BIT_dat_rtc)>>PIN_dat_rtc)<<i;
 529  00c6 7b02          	ld	a,(OFST+0,sp)
 530  00c8 5f            	clrw	x
 531  00c9 97            	ld	xl,a
 532  00ca c6500b        	ld	a,20491
 533  00cd 4e            	swap	a
 534  00ce a40f          	and	a,#15
 535  00d0 a401          	and	a,#1
 536  00d2 5d            	tnzw	x
 537  00d3 2704          	jreq	L61
 538  00d5               L02:
 539  00d5 48            	sll	a
 540  00d6 5a            	decw	x
 541  00d7 26fc          	jrne	L02
 542  00d9               L61:
 543  00d9 1a01          	or	a,(OFST-1,sp)
 544  00db 6b01          	ld	(OFST-1,sp),a
 546                     ; 62     nop();
 549  00dd 9d            nop
 551                     ; 63     GPIOC->ODR&=~BIT_clk_rtc;// clk=0
 554  00de 721b500a      	bres	20490,#5
 555                     ; 64     nop();
 558  00e2 9d            nop
 560                     ; 57   for(i=0;i<=7;i++) {
 563  00e3 0c02          	inc	(OFST+0,sp)
 567  00e5 7b02          	ld	a,(OFST+0,sp)
 568  00e7 a108          	cp	a,#8
 569  00e9 25d5          	jrult	L371
 570                     ; 66     GPIOC->CR1|=BIT_dat_rtc;
 572  00eb 7218500d      	bset	20493,#4
 573                     ; 67     GPIOC->DDR|=BIT_dat_rtc;
 575  00ef 7218500c      	bset	20492,#4
 576                     ; 68     return (data);
 578  00f3 7b01          	ld	a,(OFST-1,sp)
 581  00f5 85            	popw	x
 582  00f6 81            	ret
 628                     ; 71 void send_rtc(char reg_adr, char data) { 
 629                     	switch	.text
 630  00f7               _send_rtc:
 632  00f7 89            	pushw	x
 633  00f8 88            	push	a
 634       00000001      OFST:	set	1
 637                     ; 72   data = ((data/10)<<4) | data%10;
 639  00f9 7b03          	ld	a,(OFST+2,sp)
 640  00fb 5f            	clrw	x
 641  00fc 97            	ld	xl,a
 642  00fd a60a          	ld	a,#10
 643  00ff 62            	div	x,a
 644  0100 5f            	clrw	x
 645  0101 97            	ld	xl,a
 646  0102 9f            	ld	a,xl
 647  0103 6b01          	ld	(OFST+0,sp),a
 649  0105 7b03          	ld	a,(OFST+2,sp)
 650  0107 5f            	clrw	x
 651  0108 97            	ld	xl,a
 652  0109 a60a          	ld	a,#10
 653  010b 62            	div	x,a
 654  010c 9f            	ld	a,xl
 655  010d 97            	ld	xl,a
 656  010e a610          	ld	a,#16
 657  0110 42            	mul	x,a
 658  0111 9f            	ld	a,xl
 659  0112 1a01          	or	a,(OFST+0,sp)
 660  0114 6b03          	ld	(OFST+2,sp),a
 661                     ; 73   delay_rtc(3); //9*0.5us 
 663  0116 a603          	ld	a,#3
 664  0118 cd0000        	call	_delay_rtc
 666                     ; 74   GPIOA->ODR|=BIT_rst_rtc; //rst=1(>4us)
 668  011b 72165000      	bset	20480,#3
 669                     ; 75   delay_rtc(3); //9*0.5us 
 671  011f a603          	ld	a,#3
 672  0121 cd0000        	call	_delay_rtc
 674                     ; 76   reg_adr<<=1;
 676  0124 0802          	sll	(OFST+1,sp)
 677                     ; 77   reg_adr+=0x80;
 679  0126 7b02          	ld	a,(OFST+1,sp)
 680  0128 ab80          	add	a,#128
 681  012a 6b02          	ld	(OFST+1,sp),a
 682                     ; 78   send_byte_rtc(reg_adr);
 684  012c 7b02          	ld	a,(OFST+1,sp)
 685  012e cd0084        	call	_send_byte_rtc
 687                     ; 79   nop();
 690  0131 9d            nop
 692                     ; 80   send_byte_rtc(data);
 695  0132 7b03          	ld	a,(OFST+2,sp)
 696  0134 cd0084        	call	_send_byte_rtc
 698                     ; 81   GPIOA->ODR&=~BIT_rst_rtc; //rst=0
 700  0137 72175000      	bres	20480,#3
 701                     ; 82 }
 704  013b 5b03          	addw	sp,#3
 705  013d 81            	ret
 751                     ; 84 char receive_rtc(char reg_adr) {
 752                     	switch	.text
 753  013e               _receive_rtc:
 755  013e 88            	push	a
 756  013f 88            	push	a
 757       00000001      OFST:	set	1
 760                     ; 86   delay_rtc(3); //9*0.5us 
 762  0140 a603          	ld	a,#3
 763  0142 cd0000        	call	_delay_rtc
 765                     ; 87   GPIOA->ODR|=BIT_rst_rtc; //rst=1(>4us)
 767  0145 72165000      	bset	20480,#3
 768                     ; 88   delay_rtc(3); //9*0.5us 
 770  0149 a603          	ld	a,#3
 771  014b cd0000        	call	_delay_rtc
 773                     ; 89   reg_adr<<=1;
 775  014e 0802          	sll	(OFST+1,sp)
 776                     ; 90   reg_adr+=0x81;
 778  0150 7b02          	ld	a,(OFST+1,sp)
 779  0152 ab81          	add	a,#129
 780  0154 6b02          	ld	(OFST+1,sp),a
 781                     ; 91   send_byte_rtc(reg_adr);
 783  0156 7b02          	ld	a,(OFST+1,sp)
 784  0158 cd0084        	call	_send_byte_rtc
 786                     ; 92   receive_data=receive_byte_rtc();
 788  015b cd00b2        	call	_receive_byte_rtc
 790  015e 6b01          	ld	(OFST+0,sp),a
 792                     ; 93   GPIOA->ODR&=~BIT_rst_rtc; //rst=0
 794  0160 72175000      	bres	20480,#3
 795                     ; 94   return receive_data;
 797  0164 7b01          	ld	a,(OFST+0,sp)
 800  0166 85            	popw	x
 801  0167 81            	ret
 846                     ; 97 char receive_plain_val_rtc(char reg_adr) {
 847                     	switch	.text
 848  0168               _receive_plain_val_rtc:
 850  0168 89            	pushw	x
 851       00000002      OFST:	set	2
 854                     ; 99   val = receive_rtc(reg_adr);
 856  0169 add3          	call	_receive_rtc
 858  016b 6b02          	ld	(OFST+0,sp),a
 860                     ; 100   return ((val & 0xf0)>>4) * 10 + (val & 0x0f);
 862  016d 7b02          	ld	a,(OFST+0,sp)
 863  016f a40f          	and	a,#15
 864  0171 6b01          	ld	(OFST-1,sp),a
 866  0173 7b02          	ld	a,(OFST+0,sp)
 867  0175 4e            	swap	a
 868  0176 a40f          	and	a,#15
 869  0178 97            	ld	xl,a
 870  0179 a60a          	ld	a,#10
 871  017b 42            	mul	x,a
 872  017c 9f            	ld	a,xl
 873  017d 1b01          	add	a,(OFST-1,sp)
 876  017f 85            	popw	x
 877  0180 81            	ret
 880                     	xref.b	_secondsRtcUtcCache
 934                     .const:	section	.text
 935  0000               L43:
 936  0000 00015180      	dc.l	86400
 937                     ; 108 unsigned long receiveEpochSecondsRtcMoscow() {
 938                     	switch	.text
 939  0181               _receiveEpochSecondsRtcMoscow:
 941  0181 5205          	subw	sp,#5
 942       00000005      OFST:	set	5
 945                     ; 113   char currentSec = receive_plain_val_rtc(SEC);
 947  0183 4f            	clr	a
 948  0184 ade2          	call	_receive_plain_val_rtc
 950  0186 6b05          	ld	(OFST+0,sp),a
 952                     ; 114   if(currentSec == secondsRtcUtcCache.sec && secondsRtcUtcCache.cacheEneble) {
 954  0188 7b05          	ld	a,(OFST+0,sp)
 955  018a b104          	cp	a,_secondsRtcUtcCache+4
 956  018c 260c          	jrne	L513
 958  018e 3d10          	tnz	_secondsRtcUtcCache+16
 959  0190 2708          	jreq	L513
 960                     ; 115     return secondsRtcUtcCache.epochSec;
 962  0192 ae0000        	ldw	x,#_secondsRtcUtcCache
 963  0195 cd0000        	call	c_ltor
 966  0198 2040          	jra	L63
 967  019a               L513:
 968                     ; 117   secondsRtcUtcCache.sec = currentSec;
 970  019a 7b05          	ld	a,(OFST+0,sp)
 971  019c b704          	ld	_secondsRtcUtcCache+4,a
 972                     ; 118   currentMinFromMidnight = ((unsigned int)receive_plain_val_rtc(HR) * 60) + receive_plain_val_rtc(MIN); 
 974  019e a601          	ld	a,#1
 975  01a0 adc6          	call	_receive_plain_val_rtc
 977  01a2 6b01          	ld	(OFST-4,sp),a
 979  01a4 a602          	ld	a,#2
 980  01a6 adc0          	call	_receive_plain_val_rtc
 982  01a8 5f            	clrw	x
 983  01a9 97            	ld	xl,a
 984  01aa a63c          	ld	a,#60
 985  01ac cd0000        	call	c_bmulx
 987  01af 01            	rrwa	x,a
 988  01b0 1b01          	add	a,(OFST-4,sp)
 989  01b2 2401          	jrnc	L23
 990  01b4 5c            	incw	x
 991  01b5               L23:
 992  01b5 02            	rlwa	x,a
 993  01b6 1f03          	ldw	(OFST-2,sp),x
 994  01b8 01            	rrwa	x,a
 996                     ; 119    if(currentMinFromMidnight == secondsRtcUtcCache.minFromMidnight && secondsRtcUtcCache.cacheEneble) {
 998  01b9 1e03          	ldw	x,(OFST-2,sp)
 999  01bb b309          	cpw	x,_secondsRtcUtcCache+9
1000  01bd 261e          	jrne	L713
1002  01bf 3d10          	tnz	_secondsRtcUtcCache+16
1003  01c1 271a          	jreq	L713
1004                     ; 120     secondsRtcUtcCache.epochSec =  secondsRtcUtcCache.epochSecToMimute + currentSec;
1006  01c3 ae0005        	ldw	x,#_secondsRtcUtcCache+5
1007  01c6 cd0000        	call	c_ltor
1009  01c9 7b05          	ld	a,(OFST+0,sp)
1010  01cb cd0000        	call	c_ladc
1012  01ce ae0000        	ldw	x,#_secondsRtcUtcCache
1013  01d1 cd0000        	call	c_rtol
1015                     ; 121     return secondsRtcUtcCache.epochSec;
1017  01d4 ae0000        	ldw	x,#_secondsRtcUtcCache
1018  01d7 cd0000        	call	c_ltor
1021  01da               L63:
1023  01da 5b05          	addw	sp,#5
1024  01dc 81            	ret
1025  01dd               L713:
1026                     ; 123   secondsRtcUtcCache.minFromMidnight = currentMinFromMidnight;
1028  01dd 1e03          	ldw	x,(OFST-2,sp)
1029  01df bf09          	ldw	_secondsRtcUtcCache+9,x
1030                     ; 125   dayOfMonth = receive_plain_val_rtc(DATE);
1032  01e1 a603          	ld	a,#3
1033  01e3 ad83          	call	_receive_plain_val_rtc
1035  01e5 6b02          	ld	(OFST-3,sp),a
1037                     ; 126   if(dayOfMonth == secondsRtcUtcCache.day && secondsRtcUtcCache.cacheEneble) {
1039  01e7 7b02          	ld	a,(OFST-3,sp)
1040  01e9 b10f          	cp	a,_secondsRtcUtcCache+15
1041  01eb 2630          	jrne	L123
1043  01ed 3d10          	tnz	_secondsRtcUtcCache+16
1044  01ef 272c          	jreq	L123
1045                     ; 127      secondsRtcUtcCache.epochSecToMimute = secondsRtcUtcCache.epochSecToDay + ((unsigned long)currentMinFromMidnight) * 60;
1047  01f1 1e03          	ldw	x,(OFST-2,sp)
1048  01f3 a63c          	ld	a,#60
1049  01f5 cd0000        	call	c_cmulx
1051  01f8 ae000b        	ldw	x,#_secondsRtcUtcCache+11
1052  01fb cd0000        	call	c_ladd
1054  01fe ae0005        	ldw	x,#_secondsRtcUtcCache+5
1055  0201 cd0000        	call	c_rtol
1057                     ; 128      secondsRtcUtcCache.epochSec = secondsRtcUtcCache.epochSecToMimute + currentSec;
1059  0204 ae0005        	ldw	x,#_secondsRtcUtcCache+5
1060  0207 cd0000        	call	c_ltor
1062  020a 7b05          	ld	a,(OFST+0,sp)
1063  020c cd0000        	call	c_ladc
1065  020f ae0000        	ldw	x,#_secondsRtcUtcCache
1066  0212 cd0000        	call	c_rtol
1068                     ; 129      return secondsRtcUtcCache.epochSec;
1070  0215 ae0000        	ldw	x,#_secondsRtcUtcCache
1071  0218 cd0000        	call	c_ltor
1074  021b 20bd          	jra	L63
1075  021d               L123:
1076                     ; 131   secondsRtcUtcCache.day = dayOfMonth;
1078  021d 7b02          	ld	a,(OFST-3,sp)
1079  021f b70f          	ld	_secondsRtcUtcCache+15,a
1080                     ; 133   secondsRtcUtcCache.epochSecToDay = getEpochDaysOfDate(receive_plain_val_rtc(YEAR), receive_plain_val_rtc(MONTH), dayOfMonth) * SECOND_PER_DAY;
1082  0221 7b02          	ld	a,(OFST-3,sp)
1083  0223 88            	push	a
1084  0224 a604          	ld	a,#4
1085  0226 cd0168        	call	_receive_plain_val_rtc
1087  0229 97            	ld	xl,a
1088  022a 89            	pushw	x
1089  022b a606          	ld	a,#6
1090  022d cd0168        	call	_receive_plain_val_rtc
1092  0230 85            	popw	x
1093  0231 95            	ld	xh,a
1094  0232 ad3f          	call	_getEpochDaysOfDate
1096  0234 84            	pop	a
1097  0235 ae0000        	ldw	x,#L43
1098  0238 cd0000        	call	c_lmul
1100  023b ae000b        	ldw	x,#_secondsRtcUtcCache+11
1101  023e cd0000        	call	c_rtol
1103                     ; 134   secondsRtcUtcCache.epochSecToMimute = secondsRtcUtcCache.epochSecToDay + ((unsigned long)currentMinFromMidnight) * 60;
1105  0241 1e03          	ldw	x,(OFST-2,sp)
1106  0243 a63c          	ld	a,#60
1107  0245 cd0000        	call	c_cmulx
1109  0248 ae000b        	ldw	x,#_secondsRtcUtcCache+11
1110  024b cd0000        	call	c_ladd
1112  024e ae0005        	ldw	x,#_secondsRtcUtcCache+5
1113  0251 cd0000        	call	c_rtol
1115                     ; 135   secondsRtcUtcCache.epochSec = secondsRtcUtcCache.epochSecToMimute + currentSec;
1117  0254 ae0005        	ldw	x,#_secondsRtcUtcCache+5
1118  0257 cd0000        	call	c_ltor
1120  025a 7b05          	ld	a,(OFST+0,sp)
1121  025c cd0000        	call	c_ladc
1123  025f ae0000        	ldw	x,#_secondsRtcUtcCache
1124  0262 cd0000        	call	c_rtol
1126                     ; 136   secondsRtcUtcCache.cacheEneble = 1;
1128  0265 35010010      	mov	_secondsRtcUtcCache+16,#1
1129                     ; 137   return secondsRtcUtcCache.epochSec;
1131  0269 ae0000        	ldw	x,#_secondsRtcUtcCache
1132  026c cd0000        	call	c_ltor
1135  026f acda01da      	jpf	L63
1207                     ; 140 unsigned long getEpochDaysOfDate(char year, char month, char day) {
1208                     	switch	.text
1209  0273               _getEpochDaysOfDate:
1211  0273 89            	pushw	x
1212  0274 5206          	subw	sp,#6
1213       00000006      OFST:	set	6
1216                     ; 141   unsigned long result = 0;
1218  0276 ae0000        	ldw	x,#0
1219  0279 1f03          	ldw	(OFST-3,sp),x
1220  027b ae0000        	ldw	x,#0
1221  027e 1f01          	ldw	(OFST-5,sp),x
1223                     ; 144   for (i = FIRST_YEAR; i < (year + 2000); i++) {
1225  0280 ae07b2        	ldw	x,#1970
1226  0283 1f05          	ldw	(OFST-1,sp),x
1229  0285 2021          	jra	L563
1230  0287               L163:
1231                     ; 145     result += isLeapYear(i) ? LEAP_DAYS : NON_LEAP_DAYS;
1233  0287 1e05          	ldw	x,(OFST-1,sp)
1234  0289 cd05af        	call	_isLeapYear
1236  028c 4d            	tnz	a
1237  028d 2705          	jreq	L24
1238  028f ae016e        	ldw	x,#366
1239  0292 2003          	jra	L44
1240  0294               L24:
1241  0294 ae016d        	ldw	x,#365
1242  0297               L44:
1243  0297 cd0000        	call	c_itolx
1245  029a 96            	ldw	x,sp
1246  029b 1c0001        	addw	x,#OFST-5
1247  029e cd0000        	call	c_lgadd
1250                     ; 144   for (i = FIRST_YEAR; i < (year + 2000); i++) {
1252  02a1 1e05          	ldw	x,(OFST-1,sp)
1253  02a3 1c0001        	addw	x,#1
1254  02a6 1f05          	ldw	(OFST-1,sp),x
1256  02a8               L563:
1259  02a8 9c            	rvf
1260  02a9 7b07          	ld	a,(OFST+1,sp)
1261  02ab 5f            	clrw	x
1262  02ac 97            	ld	xl,a
1263  02ad 1c07d0        	addw	x,#2000
1264  02b0 1305          	cpw	x,(OFST-1,sp)
1265  02b2 2cd3          	jrsgt	L163
1266                     ; 147   for (i = 1; i < month; i++) {
1268  02b4 ae0001        	ldw	x,#1
1269  02b7 1f05          	ldw	(OFST-1,sp),x
1272  02b9 201f          	jra	L573
1273  02bb               L173:
1274                     ; 148     result += getMonthLength(i, isLeapYear(year + 2000));
1276  02bb 7b07          	ld	a,(OFST+1,sp)
1277  02bd 5f            	clrw	x
1278  02be 97            	ld	xl,a
1279  02bf 1c07d0        	addw	x,#2000
1280  02c2 cd05af        	call	_isLeapYear
1282  02c5 97            	ld	xl,a
1283  02c6 7b06          	ld	a,(OFST+0,sp)
1284  02c8 95            	ld	xh,a
1285  02c9 cd05dc        	call	_getMonthLength
1287  02cc 96            	ldw	x,sp
1288  02cd 1c0001        	addw	x,#OFST-5
1289  02d0 cd0000        	call	c_lgadc
1292                     ; 147   for (i = 1; i < month; i++) {
1294  02d3 1e05          	ldw	x,(OFST-1,sp)
1295  02d5 1c0001        	addw	x,#1
1296  02d8 1f05          	ldw	(OFST-1,sp),x
1298  02da               L573:
1301  02da 9c            	rvf
1302  02db 7b08          	ld	a,(OFST+2,sp)
1303  02dd 5f            	clrw	x
1304  02de 97            	ld	xl,a
1305  02df bf00          	ldw	c_x,x
1306  02e1 1e05          	ldw	x,(OFST-1,sp)
1307  02e3 b300          	cpw	x,c_x
1308  02e5 2fd4          	jrslt	L173
1309                     ; 150   return result + day - 1;;
1311  02e7 96            	ldw	x,sp
1312  02e8 1c0001        	addw	x,#OFST-5
1313  02eb cd0000        	call	c_ltor
1315  02ee 7b0b          	ld	a,(OFST+5,sp)
1316  02f0 cd0000        	call	c_ladc
1318  02f3 a601          	ld	a,#1
1319  02f5 cd0000        	call	c_lsbc
1323  02f8 5b08          	addw	sp,#8
1324  02fa 81            	ret
1327                     	xref.b	_transferBody
1328                     	xref.b	_timeTransferBodyCache
1383                     	switch	.const
1384  0004               L05:
1385  0004 0000003c      	dc.l	60
1386  0008               L25:
1387  0008 00000018      	dc.l	24
1388                     ; 155 void refreshTimeTransferBody(void) {  
1389                     	switch	.text
1390  02fb               _refreshTimeTransferBody:
1392  02fb 520c          	subw	sp,#12
1393       0000000c      OFST:	set	12
1396                     ; 162   unsigned long epochRawSec = receiveEpochSecondsRtcMoscow();
1398  02fd cd0181        	call	_receiveEpochSecondsRtcMoscow
1400  0300 96            	ldw	x,sp
1401  0301 1c0009        	addw	x,#OFST-3
1402  0304 cd0000        	call	c_rtol
1405                     ; 164   if (timeTransferBodyCache.epochRawSeconds == epochRawSec && timeTransferBodyCache.cacheEneble) {
1407  0307 ae0000        	ldw	x,#_timeTransferBodyCache
1408  030a cd0000        	call	c_ltor
1410  030d 96            	ldw	x,sp
1411  030e 1c0009        	addw	x,#OFST-3
1412  0311 cd0000        	call	c_lcmp
1414  0314 2607          	jrne	L724
1416  0316 3d08          	tnz	_timeTransferBodyCache+8
1417  0318 2703          	jreq	L65
1418  031a cc03c3        	jp	L45
1419  031d               L65:
1420                     ; 165     return;
1422  031d               L724:
1423                     ; 167   timeTransferBodyCache.epochRawSeconds = epochRawSec;
1425  031d 1e0b          	ldw	x,(OFST-1,sp)
1426  031f bf02          	ldw	_timeTransferBodyCache+2,x
1427  0321 1e09          	ldw	x,(OFST-3,sp)
1428  0323 bf00          	ldw	_timeTransferBodyCache,x
1429                     ; 169   actual_now =  getActualSeconds(epochRawSec);    
1431  0325 1e0b          	ldw	x,(OFST-1,sp)
1432  0327 89            	pushw	x
1433  0328 1e0b          	ldw	x,(OFST-1,sp)
1434  032a 89            	pushw	x
1435  032b cd03c6        	call	_getActualSeconds
1437  032e 5b04          	addw	sp,#4
1438  0330 96            	ldw	x,sp
1439  0331 1c0009        	addw	x,#OFST-3
1440  0334 cd0000        	call	c_rtol
1443                     ; 171   date = getDateFromEpochDays(actual_now / SECOND_PER_DAY);
1445  0337 96            	ldw	x,sp
1446  0338 1c0009        	addw	x,#OFST-3
1447  033b cd0000        	call	c_ltor
1449  033e ae0000        	ldw	x,#L43
1450  0341 cd0000        	call	c_ludv
1452  0344 be02          	ldw	x,c_lreg+2
1453  0346 89            	pushw	x
1454  0347 96            	ldw	x,sp
1455  0348 1c0007        	addw	x,#OFST-5
1456  034b 89            	pushw	x
1457  034c cd04b6        	call	_getDateFromEpochDays
1459  034f 5b04          	addw	sp,#4
1460                     ; 172   transferBody.dayOfMonth = date.dayOfMonth;
1462  0351 7b08          	ld	a,(OFST-4,sp)
1463  0353 b702          	ld	_transferBody+2,a
1464                     ; 173   transferBody.month      = date.month;
1466  0355 7b07          	ld	a,(OFST-5,sp)
1467  0357 b701          	ld	_transferBody+1,a
1468                     ; 174   transferBody.year       = date.year % 100;  
1470  0359 1e05          	ldw	x,(OFST-7,sp)
1471  035b a664          	ld	a,#100
1472  035d cd0000        	call	c_smodx
1474  0360 01            	rrwa	x,a
1475  0361 b700          	ld	_transferBody,a
1476  0363 02            	rlwa	x,a
1477                     ; 176   transferBody.sec = actual_now % 60;
1479  0364 96            	ldw	x,sp
1480  0365 1c0009        	addw	x,#OFST-3
1481  0368 cd0000        	call	c_ltor
1483  036b ae0004        	ldw	x,#L05
1484  036e cd0000        	call	c_lumd
1486  0371 b603          	ld	a,c_lreg+3
1487  0373 b705          	ld	_transferBody+5,a
1488                     ; 177   actual_now /= 60; 
1490  0375 96            	ldw	x,sp
1491  0376 1c0009        	addw	x,#OFST-3
1492  0379 cd0000        	call	c_ltor
1494  037c ae0004        	ldw	x,#L05
1495  037f cd0000        	call	c_ludv
1497  0382 96            	ldw	x,sp
1498  0383 1c0009        	addw	x,#OFST-3
1499  0386 cd0000        	call	c_rtol
1502                     ; 179   transferBody.min = actual_now % 60;
1504  0389 96            	ldw	x,sp
1505  038a 1c0009        	addw	x,#OFST-3
1506  038d cd0000        	call	c_ltor
1508  0390 ae0004        	ldw	x,#L05
1509  0393 cd0000        	call	c_lumd
1511  0396 b603          	ld	a,c_lreg+3
1512  0398 b704          	ld	_transferBody+4,a
1513                     ; 180   actual_now /= 60;  
1515  039a 96            	ldw	x,sp
1516  039b 1c0009        	addw	x,#OFST-3
1517  039e cd0000        	call	c_ltor
1519  03a1 ae0004        	ldw	x,#L05
1520  03a4 cd0000        	call	c_ludv
1522  03a7 96            	ldw	x,sp
1523  03a8 1c0009        	addw	x,#OFST-3
1524  03ab cd0000        	call	c_rtol
1527                     ; 182   transferBody.hr  = actual_now % 24;  
1529  03ae 96            	ldw	x,sp
1530  03af 1c0009        	addw	x,#OFST-3
1531  03b2 cd0000        	call	c_ltor
1533  03b5 ae0008        	ldw	x,#L25
1534  03b8 cd0000        	call	c_lumd
1536  03bb b603          	ld	a,c_lreg+3
1537  03bd b703          	ld	_transferBody+3,a
1538                     ; 184   timeTransferBodyCache.cacheEneble = 1;
1540  03bf 35010008      	mov	_timeTransferBodyCache+8,#1
1541                     ; 185  }
1542  03c3               L45:
1545  03c3 5b0c          	addw	sp,#12
1546  03c5 81            	ret
1549                     	xref.b	_timeAlignment
1550                     	xref.b	_alignmentTimeCache
1619                     	switch	.const
1620  000c               L26:
1621  000c 00000e10      	dc.l	3600
1622  0010               L66:
1623  0010 00000064      	dc.l	100
1624  0014               L07:
1625  0014 0083d600      	dc.l	8640000
1626                     ; 187 unsigned long getActualSeconds(unsigned long epochRawSec) {
1627                     	switch	.text
1628  03c6               _getActualSeconds:
1630  03c6 520e          	subw	sp,#14
1631       0000000e      OFST:	set	14
1634                     ; 192   unsigned long secFromFirst = epochRawSec - timeAlignment.epochSecFirstPoint;
1636  03c8 96            	ldw	x,sp
1637  03c9 1c0011        	addw	x,#OFST+3
1638  03cc cd0000        	call	c_ltor
1640  03cf ae0000        	ldw	x,#_timeAlignment
1641  03d2 cd0000        	call	c_lsub
1643  03d5 96            	ldw	x,sp
1644  03d6 1c0005        	addw	x,#OFST-9
1645  03d9 cd0000        	call	c_rtol
1648                     ; 194   unsigned long hoursFromFirst = secFromFirst / 3600;
1650  03dc 96            	ldw	x,sp
1651  03dd 1c0005        	addw	x,#OFST-9
1652  03e0 cd0000        	call	c_ltor
1654  03e3 ae000c        	ldw	x,#L26
1655  03e6 cd0000        	call	c_ludv
1657  03e9 96            	ldw	x,sp
1658  03ea 1c000b        	addw	x,#OFST-3
1659  03ed cd0000        	call	c_rtol
1662                     ; 198   if (alignmentTimeCache.hoursFromFirst != hoursFromFirst || !alignmentTimeCache.cacheEneble) {
1664  03f0 ae0000        	ldw	x,#_alignmentTimeCache
1665  03f3 cd0000        	call	c_ltor
1667  03f6 96            	ldw	x,sp
1668  03f7 1c000b        	addw	x,#OFST-3
1669  03fa cd0000        	call	c_lcmp
1671  03fd 2607          	jrne	L174
1673  03ff 3d08          	tnz	_alignmentTimeCache+8
1674  0401 2703          	jreq	L47
1675  0403 cc048f        	jp	L764
1676  0406               L47:
1677  0406               L174:
1678                     ; 199     alignmentTimeCache.hoursFromFirst = hoursFromFirst;
1680  0406 1e0d          	ldw	x,(OFST-1,sp)
1681  0408 bf02          	ldw	_alignmentTimeCache+2,x
1682  040a 1e0b          	ldw	x,(OFST-3,sp)
1683  040c bf00          	ldw	_alignmentTimeCache,x
1684                     ; 200     daysFromFirst = hoursFromFirst / 24;
1686  040e 96            	ldw	x,sp
1687  040f 1c000b        	addw	x,#OFST-3
1688  0412 cd0000        	call	c_ltor
1690  0415 ae0008        	ldw	x,#L25
1691  0418 cd0000        	call	c_ludv
1693  041b 96            	ldw	x,sp
1694  041c 1c000b        	addw	x,#OFST-3
1695  041f cd0000        	call	c_rtol
1698                     ; 201     correctionDecaMsPerDay = (unsigned int) timeAlignment.timeCorrSec * 100 + timeAlignment.timeCorrDecaMs; 
1700  0422 b608          	ld	a,_timeAlignment+8
1701  0424 5f            	clrw	x
1702  0425 97            	ld	xl,a
1703  0426 a664          	ld	a,#100
1704  0428 cd0000        	call	c_bmulx
1706  042b 01            	rrwa	x,a
1707  042c bb0a          	add	a,_timeAlignment+10
1708  042e 2401          	jrnc	L46
1709  0430 5c            	incw	x
1710  0431               L46:
1711  0431 02            	rlwa	x,a
1712  0432 1f09          	ldw	(OFST-5,sp),x
1713  0434 01            	rrwa	x,a
1715                     ; 202     timeAlignment.shiftSeconds = daysFromFirst * (correctionDecaMsPerDay) / 100;
1717  0435 1e09          	ldw	x,(OFST-5,sp)
1718  0437 cd0000        	call	c_uitolx
1720  043a 96            	ldw	x,sp
1721  043b 1c0001        	addw	x,#OFST-13
1722  043e cd0000        	call	c_rtol
1725  0441 96            	ldw	x,sp
1726  0442 1c000b        	addw	x,#OFST-3
1727  0445 cd0000        	call	c_ltor
1729  0448 96            	ldw	x,sp
1730  0449 1c0001        	addw	x,#OFST-13
1731  044c cd0000        	call	c_lmul
1733  044f ae0010        	ldw	x,#L66
1734  0452 cd0000        	call	c_ludv
1736  0455 ae0004        	ldw	x,#_timeAlignment+4
1737  0458 cd0000        	call	c_rtol
1739                     ; 203     timeAlignment.shiftSeconds += ((secFromFirst % SECOND_PER_DAY) * (correctionDecaMsPerDay)) / 3600 / 2400;
1741  045b 1e09          	ldw	x,(OFST-5,sp)
1742  045d cd0000        	call	c_uitolx
1744  0460 96            	ldw	x,sp
1745  0461 1c0001        	addw	x,#OFST-13
1746  0464 cd0000        	call	c_rtol
1749  0467 96            	ldw	x,sp
1750  0468 1c0005        	addw	x,#OFST-9
1751  046b cd0000        	call	c_ltor
1753  046e ae0000        	ldw	x,#L43
1754  0471 cd0000        	call	c_lumd
1756  0474 96            	ldw	x,sp
1757  0475 1c0001        	addw	x,#OFST-13
1758  0478 cd0000        	call	c_lmul
1760  047b ae0014        	ldw	x,#L07
1761  047e cd0000        	call	c_ludv
1763  0481 ae0004        	ldw	x,#_timeAlignment+4
1764  0484 cd0000        	call	c_lgadd
1766                     ; 204     alignmentTimeCache.shiftSeconds = timeAlignment.shiftSeconds;
1768  0487 be06          	ldw	x,_timeAlignment+6
1769  0489 bf06          	ldw	_alignmentTimeCache+6,x
1770  048b be04          	ldw	x,_timeAlignment+4
1771  048d bf04          	ldw	_alignmentTimeCache+4,x
1772  048f               L764:
1773                     ; 206   alignmentTimeCache.cacheEneble = 1;
1775  048f 35010008      	mov	_alignmentTimeCache+8,#1
1776                     ; 207   if (timeAlignment.positiveCorr) return epochRawSec + timeAlignment.shiftSeconds;
1778  0493 3d09          	tnz	_timeAlignment+9
1779  0495 270f          	jreq	L374
1782  0497 96            	ldw	x,sp
1783  0498 1c0011        	addw	x,#OFST+3
1784  049b cd0000        	call	c_ltor
1786  049e ae0004        	ldw	x,#_timeAlignment+4
1787  04a1 cd0000        	call	c_ladd
1790  04a4 200d          	jra	L27
1791  04a6               L374:
1792                     ; 208   return epochRawSec - timeAlignment.shiftSeconds;
1794  04a6 96            	ldw	x,sp
1795  04a7 1c0011        	addw	x,#OFST+3
1796  04aa cd0000        	call	c_ltor
1798  04ad ae0004        	ldw	x,#_timeAlignment+4
1799  04b0 cd0000        	call	c_lsub
1802  04b3               L27:
1804  04b3 5b0e          	addw	sp,#14
1805  04b5 81            	ret
1808                     	xref.b	_dateFromEpochDaysCache
1890                     ; 211 LocalDate getDateFromEpochDays(unsigned int days) {
1891                     	switch	.text
1892  04b6               _getDateFromEpochDays:
1894  04b6 520e          	subw	sp,#14
1895       0000000e      OFST:	set	14
1898                     ; 214    int year = FIRST_YEAR;
1900  04b8 ae07b2        	ldw	x,#1970
1901  04bb 1f0b          	ldw	(OFST-3,sp),x
1903                     ; 215    unsigned int dayCntr = 0;
1905  04bd 5f            	clrw	x
1906  04be 1f0d          	ldw	(OFST-1,sp),x
1908                     ; 216    unsigned int dayInYear = 0; 
1910  04c0 5f            	clrw	x
1911  04c1 1f09          	ldw	(OFST-5,sp),x
1913                     ; 220    if (days == dateFromEpochDaysCache.rawDays) {
1915  04c3 1e13          	ldw	x,(OFST+5,sp)
1916  04c5 b300          	cpw	x,_dateFromEpochDaysCache
1917  04c7 260e          	jrne	L735
1918                     ; 221      return dateFromEpochDaysCache.date;
1920  04c9 1e11          	ldw	x,(OFST+3,sp)
1921  04cb 90ae0002      	ldw	y,#_dateFromEpochDaysCache+2
1922  04cf a604          	ld	a,#4
1923  04d1 cd0000        	call	c_xymov
1926  04d4 cc055c        	jra	L401
1927  04d7               L735:
1928                     ; 223    dateFromEpochDaysCache.rawDays = days;
1930  04d7 1e13          	ldw	x,(OFST+5,sp)
1931  04d9 bf00          	ldw	_dateFromEpochDaysCache,x
1933  04db 2020          	jra	L545
1934  04dd               L145:
1935                     ; 227      dayCntr += dayInYear;
1937  04dd 1e0d          	ldw	x,(OFST-1,sp)
1938  04df 72fb09        	addw	x,(OFST-5,sp)
1939  04e2 1f0d          	ldw	(OFST-1,sp),x
1941                     ; 228      dayInYear = isLeapYear(year) ? LEAP_DAYS : NON_LEAP_DAYS;
1943  04e4 1e0b          	ldw	x,(OFST-3,sp)
1944  04e6 cd05af        	call	_isLeapYear
1946  04e9 4d            	tnz	a
1947  04ea 2705          	jreq	L001
1948  04ec ae016e        	ldw	x,#366
1949  04ef 2003          	jra	L201
1950  04f1               L001:
1951  04f1 ae016d        	ldw	x,#365
1952  04f4               L201:
1953  04f4 1f09          	ldw	(OFST-5,sp),x
1955                     ; 229      year++;
1957  04f6 1e0b          	ldw	x,(OFST-3,sp)
1958  04f8 1c0001        	addw	x,#1
1959  04fb 1f0b          	ldw	(OFST-3,sp),x
1961  04fd               L545:
1962                     ; 226    while (dayCntr + dayInYear <= days) {
1964  04fd 1e0d          	ldw	x,(OFST-1,sp)
1965  04ff 72fb09        	addw	x,(OFST-5,sp)
1966  0502 1313          	cpw	x,(OFST+5,sp)
1967  0504 23d7          	jrule	L145
1968                     ; 231    year--;
1970  0506 1e0b          	ldw	x,(OFST-3,sp)
1971  0508 1d0001        	subw	x,#1
1972  050b 1f0b          	ldw	(OFST-3,sp),x
1974                     ; 232    currentDays = days - dayCntr + 1;
1976  050d 1e13          	ldw	x,(OFST+5,sp)
1977  050f 72f00d        	subw	x,(OFST-1,sp)
1978  0512 5c            	incw	x
1979  0513 1f0d          	ldw	(OFST-1,sp),x
1981                     ; 234    date.year = year;
1983  0515 1e0b          	ldw	x,(OFST-3,sp)
1984  0517 1f05          	ldw	(OFST-9,sp),x
1986                     ; 235    date.month = getMonth(currentDays, year).month;
1988  0519 1e0b          	ldw	x,(OFST-3,sp)
1989  051b 89            	pushw	x
1990  051c 1e0f          	ldw	x,(OFST+1,sp)
1991  051e 89            	pushw	x
1992  051f 96            	ldw	x,sp
1993  0520 1c0005        	addw	x,#OFST-9
1994  0523 89            	pushw	x
1995  0524 ad39          	call	_getMonth
1997  0526 85            	popw	x
1998  0527 5b04          	addw	sp,#4
1999  0529 e602          	ld	a,(2,x)
2000  052b 6b07          	ld	(OFST-7,sp),a
2002                     ; 236    date.dayOfMonth = getMonth(currentDays, year).dayOfMonth;
2004  052d 1e0b          	ldw	x,(OFST-3,sp)
2005  052f 89            	pushw	x
2006  0530 1e0f          	ldw	x,(OFST+1,sp)
2007  0532 89            	pushw	x
2008  0533 96            	ldw	x,sp
2009  0534 1c0005        	addw	x,#OFST-9
2010  0537 89            	pushw	x
2011  0538 ad25          	call	_getMonth
2013  053a 85            	popw	x
2014  053b 5b04          	addw	sp,#4
2015  053d e603          	ld	a,(3,x)
2016  053f 6b08          	ld	(OFST-6,sp),a
2018                     ; 237    dateFromEpochDaysCache.date = date;
2020  0541 ae0002        	ldw	x,#_dateFromEpochDaysCache+2
2021  0544 9096          	ldw	y,sp
2022  0546 72a90005      	addw	y,#OFST-9
2023  054a a604          	ld	a,#4
2024  054c cd0000        	call	c_xymov
2026                     ; 238    return date;
2028  054f 1e11          	ldw	x,(OFST+3,sp)
2029  0551 9096          	ldw	y,sp
2030  0553 72a90005      	addw	y,#OFST-9
2031  0557 a604          	ld	a,#4
2032  0559 cd0000        	call	c_xymov
2035  055c               L401:
2037  055c 5b0e          	addw	sp,#14
2038  055e 81            	ret
2130                     ; 241 LocalDate getMonth(int days, int year) {
2131                     	switch	.text
2132  055f               _getMonth:
2134  055f 5209          	subw	sp,#9
2135       00000009      OFST:	set	9
2138                     ; 242    char month = 1;
2140  0561 a601          	ld	a,#1
2141  0563 6b05          	ld	(OFST-4,sp),a
2143                     ; 243    int dayCntr = 0;
2145  0565 5f            	clrw	x
2146  0566 1f06          	ldw	(OFST-3,sp),x
2148                     ; 244    int dayInMonth = 0;
2150  0568 5f            	clrw	x
2151  0569 1f08          	ldw	(OFST-1,sp),x
2154  056b 2017          	jra	L326
2155  056d               L716:
2156                     ; 249      dayCntr += dayInMonth;
2158  056d 1e06          	ldw	x,(OFST-3,sp)
2159  056f 72fb08        	addw	x,(OFST-1,sp)
2160  0572 1f06          	ldw	(OFST-3,sp),x
2162                     ; 250      dayInMonth = getMonthLength(month, isLeapYear(year));
2164  0574 1e10          	ldw	x,(OFST+7,sp)
2165  0576 ad37          	call	_isLeapYear
2167  0578 97            	ld	xl,a
2168  0579 7b05          	ld	a,(OFST-4,sp)
2169  057b 95            	ld	xh,a
2170  057c ad5e          	call	_getMonthLength
2172  057e 5f            	clrw	x
2173  057f 97            	ld	xl,a
2174  0580 1f08          	ldw	(OFST-1,sp),x
2176                     ; 251      month++;
2178  0582 0c05          	inc	(OFST-4,sp)
2180  0584               L326:
2181                     ; 248    while (dayCntr + dayInMonth <= days) {
2183  0584 9c            	rvf
2184  0585 1e06          	ldw	x,(OFST-3,sp)
2185  0587 72fb08        	addw	x,(OFST-1,sp)
2186  058a 130e          	cpw	x,(OFST+5,sp)
2187  058c 2ddf          	jrsle	L716
2188                     ; 253    month--;
2190  058e 0a05          	dec	(OFST-4,sp)
2192                     ; 254    currentDays = days - dayCntr;
2194  0590 1e0e          	ldw	x,(OFST+5,sp)
2195  0592 72f006        	subw	x,(OFST-3,sp)
2196  0595 1f06          	ldw	(OFST-3,sp),x
2198                     ; 256    date.month = month;
2200  0597 7b05          	ld	a,(OFST-4,sp)
2201  0599 6b03          	ld	(OFST-6,sp),a
2203                     ; 257    date.dayOfMonth = currentDays;
2205  059b 7b07          	ld	a,(OFST-2,sp)
2206  059d 6b04          	ld	(OFST-5,sp),a
2208                     ; 258    return date;
2210  059f 1e0c          	ldw	x,(OFST+3,sp)
2211  05a1 9096          	ldw	y,sp
2212  05a3 72a90001      	addw	y,#OFST-8
2213  05a7 a604          	ld	a,#4
2214  05a9 cd0000        	call	c_xymov
2218  05ac 5b09          	addw	sp,#9
2219  05ae 81            	ret
2253                     ; 261 char isLeapYear(int year) {
2254                     	switch	.text
2255  05af               _isLeapYear:
2257  05af 89            	pushw	x
2258       00000000      OFST:	set	0
2261                     ; 262    return (year % 400) == 0 || (year % 100) != 0 && (year % 4) == 0;
2263  05b0 90ae0190      	ldw	y,#400
2264  05b4 cd0000        	call	c_idiv
2266  05b7 51            	exgw	x,y
2267  05b8 a30000        	cpw	x,#0
2268  05bb 2718          	jreq	L411
2269  05bd 1e01          	ldw	x,(OFST+1,sp)
2270  05bf a664          	ld	a,#100
2271  05c1 cd0000        	call	c_smodx
2273  05c4 a30000        	cpw	x,#0
2274  05c7 2710          	jreq	L211
2275  05c9 1e01          	ldw	x,(OFST+1,sp)
2276  05cb a604          	ld	a,#4
2277  05cd cd0000        	call	c_smodx
2279  05d0 a30000        	cpw	x,#0
2280  05d3 2604          	jrne	L211
2281  05d5               L411:
2282  05d5 a601          	ld	a,#1
2283  05d7 2001          	jra	L611
2284  05d9               L211:
2285  05d9 4f            	clr	a
2286  05da               L611:
2289  05da 85            	popw	x
2290  05db 81            	ret
2333                     	switch	.const
2334  0018               L031:
2335  0018 05ec          	dc.w	L546
2336  001a 05f4          	dc.w	L156
2337  001c 05ec          	dc.w	L546
2338  001e 05f0          	dc.w	L746
2339  0020 05ec          	dc.w	L546
2340  0022 05f0          	dc.w	L746
2341  0024 05ec          	dc.w	L546
2342  0026 05ec          	dc.w	L546
2343  0028 05f0          	dc.w	L746
2344  002a 05ec          	dc.w	L546
2345  002c 05f0          	dc.w	L746
2346  002e 05ec          	dc.w	L546
2347                     ; 265 char getMonthLength(char month, char leap) {
2348                     	switch	.text
2349  05dc               _getMonthLength:
2351  05dc 89            	pushw	x
2352       00000000      OFST:	set	0
2355                     ; 267         switch (month) {
2357  05dd 9e            	ld	a,xh
2359                     ; 280             default: return -1;
2360  05de 4a            	dec	a
2361  05df a10c          	cp	a,#12
2362  05e1 2407          	jruge	L621
2363  05e3 5f            	clrw	x
2364  05e4 97            	ld	xl,a
2365  05e5 58            	sllw	x
2366  05e6 de0018        	ldw	x,(L031,x)
2367  05e9 fc            	jp	(x)
2368  05ea               L621:
2369  05ea 2014          	jra	L356
2370  05ec               L546:
2371                     ; 268             case 1:
2371                     ; 269             case 3:
2371                     ; 270             case 5:
2371                     ; 271             case 7:
2371                     ; 272             case 8:
2371                     ; 273             case 10:
2371                     ; 274             case 12: return 31;
2373  05ec a61f          	ld	a,#31
2375  05ee 2002          	jra	L231
2376  05f0               L746:
2377                     ; 275             case 4:
2377                     ; 276             case 6:
2377                     ; 277             case 9:
2377                     ; 278             case 11: return 30;
2379  05f0 a61e          	ld	a,#30
2381  05f2               L231:
2383  05f2 85            	popw	x
2384  05f3 81            	ret
2385  05f4               L156:
2386                     ; 279             case 2: return leap ? 29 : 28;
2388  05f4 0d02          	tnz	(OFST+2,sp)
2389  05f6 2704          	jreq	L221
2390  05f8 a61d          	ld	a,#29
2391  05fa 2002          	jra	L421
2392  05fc               L221:
2393  05fc a61c          	ld	a,#28
2394  05fe               L421:
2396  05fe 20f2          	jra	L231
2397  0600               L356:
2398                     ; 280             default: return -1;
2400  0600 a6ff          	ld	a,#255
2402  0602 20ee          	jra	L231
2415                     	xdef	_getActualSeconds
2416                     	xdef	_refreshTimeTransferBody
2417                     	xdef	_receiveEpochSecondsRtcMoscow
2418                     	xdef	_getEpochDaysOfDate
2419                     	xdef	_getDateFromEpochDays
2420                     	xdef	_getMonth
2421                     	xdef	_isLeapYear
2422                     	xdef	_getMonthLength
2423                     	xdef	_receive_plain_val_rtc
2424                     	xdef	_receive_rtc
2425                     	xdef	_send_rtc
2426                     	xdef	_receive_byte_rtc
2427                     	xdef	_send_byte_rtc
2428                     	xdef	_init_rtc
2429                     	xdef	_rtc_set_time_date
2430                     	xdef	_delay_rtc
2431                     	xref.b	c_lreg
2432                     	xref.b	c_x
2451                     	xref	c_idiv
2452                     	xref	c_xymov
2453                     	xref	c_uitolx
2454                     	xref	c_lsub
2455                     	xref	c_lumd
2456                     	xref	c_ludv
2457                     	xref	c_lcmp
2458                     	xref	c_lsbc
2459                     	xref	c_lgadc
2460                     	xref	c_lgadd
2461                     	xref	c_itolx
2462                     	xref	c_lmul
2463                     	xref	c_ladd
2464                     	xref	c_cmulx
2465                     	xref	c_rtol
2466                     	xref	c_ladc
2467                     	xref	c_bmulx
2468                     	xref	c_ltor
2469                     	xref	c_smodx
2470                     	end
