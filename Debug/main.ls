   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.5 - 16 Jun 2021
   3                     ; Generator (Limited) V4.5.3 - 16 Jun 2021
  70                     ; 23 int main() { 
  72                     	switch	.text
  73  0000               _main:
  75  0000 88            	push	a
  76       00000001      OFST:	set	1
  79                     ; 24   char i=5;
  81                     ; 25   init_iic_emb_tx();
  83  0001 cd0000        	call	_init_iic_emb_tx
  85                     ; 26   init_encoder(&encoder);
  87  0004 ae0055        	ldw	x,#_encoder
  88  0007 cd0000        	call	_init_encoder
  90                     ; 27   init_rtc();
  92  000a cd0000        	call	_init_rtc
  94                     ; 28 	init_ssd1306();
  96  000d cd0000        	call	_init_ssd1306
  98                     ; 30   populate_timeAlignment_from_eeprom();
 100  0010 cd02f7        	call	_populate_timeAlignment_from_eeprom
 102                     ; 31   encoder.but_data_lim = 1;
 104  0013 35010063      	mov	_encoder+14,#1
 105  0017               L72:
 106                     ; 37 		refreshTimeTransferBody();
 108  0017 cd0000        	call	_refreshTimeTransferBody
 110                     ; 38 		i2c_wr_reg(RX_ADDR, 0x00, &transferBody.year, TRANSFERED_SIZE);
 112  001a 4b06          	push	#6
 113  001c ae0046        	ldw	x,#_transferBody
 114  001f 89            	pushw	x
 115  0020 ae0600        	ldw	x,#1536
 116  0023 cd0000        	call	_i2c_wr_reg
 118  0026 5b03          	addw	sp,#3
 119                     ; 39 		print_time();	
 121  0028 cd0000        	call	_print_time
 123                     ; 42     if (encoder.but_data != 0) {     
 125  002b 3d61          	tnz	_encoder+12
 126  002d 27e8          	jreq	L72
 127                     ; 43       menu_selector();
 129  002f ad05          	call	_menu_selector
 131                     ; 44 			oled_Clear_Screen();
 133  0031 cd0000        	call	_oled_Clear_Screen
 135  0034 20e1          	jra	L72
 319                     .const:	section	.text
 320  0000               L42:
 321  0000 00015180      	dc.l	86400
 322  0004               L62:
 323  0004 00002710      	dc.l	10000
 324                     ; 49 char menu_selector() {
 325                     	switch	.text
 326  0036               _menu_selector:
 328  0036 5215          	subw	sp,#21
 329       00000015      OFST:	set	21
 332                     ; 56 	presetTime.hr = transferBody.hr;
 334  0038 b649          	ld	a,_transferBody+3
 335  003a 6b01          	ld	(OFST-20,sp),a
 337                     ; 57 	presetTime.min = transferBody.min;
 339  003c b64a          	ld	a,_transferBody+4
 340  003e 6b02          	ld	(OFST-19,sp),a
 342                     ; 58 	oled_print_XXnumber(0, 96, 1);
 344  0040 4b01          	push	#1
 345  0042 4b60          	push	#96
 346  0044 5f            	clrw	x
 347  0045 cd0000        	call	_oled_print_XXnumber
 349  0048 85            	popw	x
 350                     ; 60 	encoder.but_data = 0;
 352  0049 3f61          	clr	_encoder+12
 353                     ; 61 	encoder_setter(0, 23, presetTime.hr);
 355  004b 7b01          	ld	a,(OFST-20,sp)
 356  004d 5f            	clrw	x
 357  004e 97            	ld	xl,a
 358  004f 89            	pushw	x
 359  0050 ae0017        	ldw	x,#23
 360  0053 89            	pushw	x
 361  0054 5f            	clrw	x
 362  0055 cd0000        	call	_encoder_setter
 364  0058 5b04          	addw	sp,#4
 365                     ; 62 	presetTime.hr = scan_value_at_pos(4);
 367  005a a604          	ld	a,#4
 368  005c cd025e        	call	_scan_value_at_pos
 370  005f 01            	rrwa	x,a
 371  0060 6b01          	ld	(OFST-20,sp),a
 372  0062 02            	rlwa	x,a
 374                     ; 63 	oled_print_XXnumber(presetTime.hr, 4, 1);
 376  0063 4b01          	push	#1
 377  0065 4b04          	push	#4
 378  0067 7b03          	ld	a,(OFST-18,sp)
 379  0069 5f            	clrw	x
 380  006a 97            	ld	xl,a
 381  006b cd0000        	call	_oled_print_XXnumber
 383  006e 85            	popw	x
 384                     ; 65 	encoder.but_data = 0;
 386  006f 3f61          	clr	_encoder+12
 387                     ; 66 	encoder_setter(0, 59, presetTime.min);
 389  0071 7b02          	ld	a,(OFST-19,sp)
 390  0073 5f            	clrw	x
 391  0074 97            	ld	xl,a
 392  0075 89            	pushw	x
 393  0076 ae003b        	ldw	x,#59
 394  0079 89            	pushw	x
 395  007a 5f            	clrw	x
 396  007b cd0000        	call	_encoder_setter
 398  007e 5b04          	addw	sp,#4
 399                     ; 67 	presetTime.min = scan_value_at_pos(50);	
 401  0080 a632          	ld	a,#50
 402  0082 cd025e        	call	_scan_value_at_pos
 404  0085 01            	rrwa	x,a
 405  0086 6b02          	ld	(OFST-19,sp),a
 406  0088 02            	rlwa	x,a
 408                     ; 70 	presetDate.dayOfMonth = transferBody.dayOfMonth;
 410  0089 b648          	ld	a,_transferBody+2
 411  008b 6b07          	ld	(OFST-14,sp),a
 413                     ; 71 	presetDate.month = transferBody.month;
 415  008d b647          	ld	a,_transferBody+1
 416  008f 6b06          	ld	(OFST-15,sp),a
 418                     ; 72   presetDate.year = transferBody.year;	
 420  0091 b646          	ld	a,_transferBody
 421  0093 5f            	clrw	x
 422  0094 97            	ld	xl,a
 423  0095 1f04          	ldw	(OFST-17,sp),x
 425                     ; 73 	oled_print_giga_char('-', 81);
 427  0097 ae2d51        	ldw	x,#11601
 428  009a cd0000        	call	_oled_print_giga_char
 430                     ; 74 	oled_print_giga_char('-', 35);
 432  009d ae2d23        	ldw	x,#11555
 433  00a0 cd0000        	call	_oled_print_giga_char
 435                     ; 75 	oled_print_XXnumber(presetDate.month, 50, 0); 
 437  00a3 4b00          	push	#0
 438  00a5 4b32          	push	#50
 439  00a7 7b08          	ld	a,(OFST-13,sp)
 440  00a9 5f            	clrw	x
 441  00aa 97            	ld	xl,a
 442  00ab cd0000        	call	_oled_print_XXnumber
 444  00ae 85            	popw	x
 445                     ; 76 	oled_print_XXnumber(presetDate.year, 96, 0);  
 447  00af 4b00          	push	#0
 448  00b1 4b60          	push	#96
 449  00b3 1e06          	ldw	x,(OFST-15,sp)
 450  00b5 cd0000        	call	_oled_print_XXnumber
 452  00b8 85            	popw	x
 453                     ; 78 	encoder.but_data = 0;
 455  00b9 3f61          	clr	_encoder+12
 456                     ; 79 	encoder_setter(1, 31, presetDate.dayOfMonth);
 458  00bb 7b07          	ld	a,(OFST-14,sp)
 459  00bd 5f            	clrw	x
 460  00be 97            	ld	xl,a
 461  00bf 89            	pushw	x
 462  00c0 ae001f        	ldw	x,#31
 463  00c3 89            	pushw	x
 464  00c4 ae0001        	ldw	x,#1
 465  00c7 cd0000        	call	_encoder_setter
 467  00ca 5b04          	addw	sp,#4
 468                     ; 80 	presetDate.dayOfMonth = scan_value_at_pos(4);
 470  00cc a604          	ld	a,#4
 471  00ce cd025e        	call	_scan_value_at_pos
 473  00d1 01            	rrwa	x,a
 474  00d2 6b07          	ld	(OFST-14,sp),a
 475  00d4 02            	rlwa	x,a
 477                     ; 81 	oled_print_XXnumber(presetDate.dayOfMonth, 4, 1);
 479  00d5 4b01          	push	#1
 480  00d7 4b04          	push	#4
 481  00d9 7b09          	ld	a,(OFST-12,sp)
 482  00db 5f            	clrw	x
 483  00dc 97            	ld	xl,a
 484  00dd cd0000        	call	_oled_print_XXnumber
 486  00e0 85            	popw	x
 487                     ; 83 	encoder.but_data = 0;
 489  00e1 3f61          	clr	_encoder+12
 490                     ; 84 	encoder_setter(1, 12, presetDate.month);
 492  00e3 7b06          	ld	a,(OFST-15,sp)
 493  00e5 5f            	clrw	x
 494  00e6 97            	ld	xl,a
 495  00e7 89            	pushw	x
 496  00e8 ae000c        	ldw	x,#12
 497  00eb 89            	pushw	x
 498  00ec ae0001        	ldw	x,#1
 499  00ef cd0000        	call	_encoder_setter
 501  00f2 5b04          	addw	sp,#4
 502                     ; 85 	presetDate.month = scan_value_at_pos(50);
 504  00f4 a632          	ld	a,#50
 505  00f6 cd025e        	call	_scan_value_at_pos
 507  00f9 01            	rrwa	x,a
 508  00fa 6b06          	ld	(OFST-15,sp),a
 509  00fc 02            	rlwa	x,a
 511                     ; 86 	oled_print_XXnumber(presetDate.month, 50, 1);
 513  00fd 4b01          	push	#1
 514  00ff 4b32          	push	#50
 515  0101 7b08          	ld	a,(OFST-13,sp)
 516  0103 5f            	clrw	x
 517  0104 97            	ld	xl,a
 518  0105 cd0000        	call	_oled_print_XXnumber
 520  0108 85            	popw	x
 521                     ; 88 	encoder.but_data = 0;
 523  0109 3f61          	clr	_encoder+12
 524                     ; 89 	encoder_setter(0, 99, presetDate.year);
 526  010b 1e04          	ldw	x,(OFST-17,sp)
 527  010d 89            	pushw	x
 528  010e ae0063        	ldw	x,#99
 529  0111 89            	pushw	x
 530  0112 5f            	clrw	x
 531  0113 cd0000        	call	_encoder_setter
 533  0116 5b04          	addw	sp,#4
 534                     ; 90 	presetDate.year = scan_value_at_pos(96);
 536  0118 a660          	ld	a,#96
 537  011a cd025e        	call	_scan_value_at_pos
 539  011d 1f04          	ldw	(OFST-17,sp),x
 541                     ; 93 	if(presetDate.dayOfMonth != transferBody.dayOfMonth || presetDate.month != transferBody.month || presetDate.year != transferBody.year || presetTime.hr != transferBody.hr || presetTime.min != transferBody.min) {
 543  011f 7b07          	ld	a,(OFST-14,sp)
 544  0121 b148          	cp	a,_transferBody+2
 545  0123 261e          	jrne	L531
 547  0125 7b06          	ld	a,(OFST-15,sp)
 548  0127 b147          	cp	a,_transferBody+1
 549  0129 2618          	jrne	L531
 551  012b b646          	ld	a,_transferBody
 552  012d 5f            	clrw	x
 553  012e 97            	ld	xl,a
 554  012f bf00          	ldw	c_x,x
 555  0131 1e04          	ldw	x,(OFST-17,sp)
 556  0133 b300          	cpw	x,c_x
 557  0135 260c          	jrne	L531
 559  0137 7b01          	ld	a,(OFST-20,sp)
 560  0139 b149          	cp	a,_transferBody+3
 561  013b 2606          	jrne	L531
 563  013d 7b02          	ld	a,(OFST-19,sp)
 564  013f b14a          	cp	a,_transferBody+4
 565  0141 272b          	jreq	L331
 566  0143               L531:
 567                     ; 94 		rtc_set_time_date(presetTime, presetDate);
 569  0143 7b07          	ld	a,(OFST-14,sp)
 570  0145 88            	push	a
 571  0146 7b07          	ld	a,(OFST-14,sp)
 572  0148 88            	push	a
 573  0149 7b07          	ld	a,(OFST-14,sp)
 574  014b 88            	push	a
 575  014c 7b07          	ld	a,(OFST-14,sp)
 576  014e 88            	push	a
 577  014f 7b07          	ld	a,(OFST-14,sp)
 578  0151 88            	push	a
 579  0152 7b07          	ld	a,(OFST-14,sp)
 580  0154 88            	push	a
 581  0155 7b07          	ld	a,(OFST-14,sp)
 582  0157 88            	push	a
 583  0158 cd0000        	call	_rtc_set_time_date
 585  015b 5b07          	addw	sp,#7
 586                     ; 95     secondsRtcUtcCache.cacheEneble = 0;
 588  015d 3f3c          	clr	_secondsRtcUtcCache+16
 589                     ; 96 		timeAlignment.epochSecFirstPoint = receiveEpochSecondsRtcMoscow();
 591  015f cd0000        	call	_receiveEpochSecondsRtcMoscow
 593  0162 ae001a        	ldw	x,#_timeAlignment
 594  0165 cd0000        	call	c_rtol
 596                     ; 97 		saveFirstPointTimeToEeprom();
 598  0168 cd02b1        	call	_saveFirstPointTimeToEeprom
 600                     ; 98 		print_save(); 
 602  016b cd0000        	call	_print_save
 604  016e               L331:
 605                     ; 102 	oled_Clear_Screen();
 607  016e cd0000        	call	_oled_Clear_Screen
 609                     ; 103 	presetCorrection.timeCorrSec = timeAlignment.timeCorrSec;
 611  0171 b622          	ld	a,_timeAlignment+8
 612  0173 6b10          	ld	(OFST-5,sp),a
 614                     ; 104 	presetCorrection.timeCorrDecaMs = timeAlignment.timeCorrDecaMs;
 616  0175 b624          	ld	a,_timeAlignment+10
 617  0177 6b12          	ld	(OFST-3,sp),a
 619                     ; 105 	presetCorrection.positiveCorr = timeAlignment.positiveCorr;
 621  0179 b623          	ld	a,_timeAlignment+9
 622  017b 6b11          	ld	(OFST-4,sp),a
 624                     ; 106 	oled_print_giga_char('.',48); 
 626  017d ae2e30        	ldw	x,#11824
 627  0180 cd0000        	call	_oled_print_giga_char
 629                     ; 107 	oled_print_XXnumber(presetCorrection.timeCorrDecaMs, 60, 0); 
 631  0183 4b00          	push	#0
 632  0185 4b3c          	push	#60
 633  0187 7b14          	ld	a,(OFST-1,sp)
 634  0189 5f            	clrw	x
 635  018a 97            	ld	xl,a
 636  018b cd0000        	call	_oled_print_XXnumber
 638  018e 85            	popw	x
 639                     ; 109 	encoder.but_data = 0;
 641  018f 3f61          	clr	_encoder+12
 642                     ; 110 	encoder_setter(-99, 99, presetCorrection.positiveCorr ? presetCorrection.timeCorrSec : -presetCorrection.timeCorrSec);
 644  0191 0d11          	tnz	(OFST-4,sp)
 645  0193 2706          	jreq	L01
 646  0195 7b10          	ld	a,(OFST-5,sp)
 647  0197 5f            	clrw	x
 648  0198 97            	ld	xl,a
 649  0199 2005          	jra	L21
 650  019b               L01:
 651  019b 7b10          	ld	a,(OFST-5,sp)
 652  019d 5f            	clrw	x
 653  019e 97            	ld	xl,a
 654  019f 50            	negw	x
 655  01a0               L21:
 656  01a0 89            	pushw	x
 657  01a1 ae0063        	ldw	x,#99
 658  01a4 89            	pushw	x
 659  01a5 aeff9d        	ldw	x,#65437
 660  01a8 cd0000        	call	_encoder_setter
 662  01ab 5b04          	addw	sp,#4
 663                     ; 111 	i = scan_value_at_pos(0);
 665  01ad 4f            	clr	a
 666  01ae cd025e        	call	_scan_value_at_pos
 668  01b1 1f14          	ldw	(OFST-1,sp),x
 670                     ; 112 	presetCorrection.timeCorrSec = (i<0) ? -i : i;
 672  01b3 9c            	rvf
 673  01b4 1e14          	ldw	x,(OFST-1,sp)
 674  01b6 2e05          	jrsge	L41
 675  01b8 7b15          	ld	a,(OFST+0,sp)
 676  01ba 40            	neg	a
 677  01bb 2002          	jra	L61
 678  01bd               L41:
 679  01bd 7b15          	ld	a,(OFST+0,sp)
 680  01bf               L61:
 681  01bf 6b10          	ld	(OFST-5,sp),a
 683                     ; 113 	presetCorrection.positiveCorr = (i<0) ? 0 : 1;
 685  01c1 9c            	rvf
 686  01c2 1e14          	ldw	x,(OFST-1,sp)
 687  01c4 2e03          	jrsge	L02
 688  01c6 4f            	clr	a
 689  01c7 2002          	jra	L22
 690  01c9               L02:
 691  01c9 a601          	ld	a,#1
 692  01cb               L22:
 693  01cb 6b11          	ld	(OFST-4,sp),a
 695                     ; 114 	oled_print_XXnumber(i, 0, 1);
 697  01cd 4b01          	push	#1
 698  01cf 4b00          	push	#0
 699  01d1 1e16          	ldw	x,(OFST+1,sp)
 700  01d3 cd0000        	call	_oled_print_XXnumber
 702  01d6 85            	popw	x
 703                     ; 116 	encoder.but_data = 0;
 705  01d7 3f61          	clr	_encoder+12
 706                     ; 117 	encoder_setter(0, 99, presetCorrection.timeCorrDecaMs);
 708  01d9 7b12          	ld	a,(OFST-3,sp)
 709  01db 5f            	clrw	x
 710  01dc 97            	ld	xl,a
 711  01dd 89            	pushw	x
 712  01de ae0063        	ldw	x,#99
 713  01e1 89            	pushw	x
 714  01e2 5f            	clrw	x
 715  01e3 cd0000        	call	_encoder_setter
 717  01e6 5b04          	addw	sp,#4
 718                     ; 118 	presetCorrection.timeCorrDecaMs = scan_value_at_pos(60);
 720  01e8 a63c          	ld	a,#60
 721  01ea ad72          	call	_scan_value_at_pos
 723  01ec 01            	rrwa	x,a
 724  01ed 6b12          	ld	(OFST-3,sp),a
 725  01ef 02            	rlwa	x,a
 727                     ; 121 	if(presetCorrection.timeCorrSec != timeAlignment.timeCorrSec || presetCorrection.timeCorrDecaMs != timeAlignment.timeCorrDecaMs || presetCorrection.positiveCorr != timeAlignment.positiveCorr) {
 729  01f0 7b10          	ld	a,(OFST-5,sp)
 730  01f2 b122          	cp	a,_timeAlignment+8
 731  01f4 260c          	jrne	L741
 733  01f6 7b12          	ld	a,(OFST-3,sp)
 734  01f8 b124          	cp	a,_timeAlignment+10
 735  01fa 2606          	jrne	L741
 737  01fc 7b11          	ld	a,(OFST-4,sp)
 738  01fe b123          	cp	a,_timeAlignment+9
 739  0200 2713          	jreq	L541
 740  0202               L741:
 741                     ; 122 		timeAlignment.timeCorrSec = presetCorrection.timeCorrSec;
 743  0202 7b10          	ld	a,(OFST-5,sp)
 744  0204 b722          	ld	_timeAlignment+8,a
 745                     ; 123 		timeAlignment.timeCorrDecaMs = presetCorrection.timeCorrDecaMs;
 747  0206 7b12          	ld	a,(OFST-3,sp)
 748  0208 b724          	ld	_timeAlignment+10,a
 749                     ; 124 		timeAlignment.positiveCorr = presetCorrection.positiveCorr;
 751  020a 7b11          	ld	a,(OFST-4,sp)
 752  020c b723          	ld	_timeAlignment+9,a
 753                     ; 125 		saveTimeCorrectionToEeprom();
 755  020e ad75          	call	_saveTimeCorrectionToEeprom
 757                     ; 126 		print_save(); 
 759  0210 cd0000        	call	_print_save
 761                     ; 127 		alignmentTimeCache.cacheEneble = 0;
 763  0213 3f54          	clr	_alignmentTimeCache+8
 764  0215               L541:
 765                     ; 131 	oled_Clear_Screen();
 767  0215 cd0000        	call	_oled_Clear_Screen
 769                     ; 132 	encoder.but_data = 0;
 771  0218 3f61          	clr	_encoder+12
 772  021a               L351:
 773                     ; 134 		i = ((receiveEpochSecondsRtcMoscow() - timeAlignment.epochSecFirstPoint) / 24 / 3600) % 10000;
 775  021a cd0000        	call	_receiveEpochSecondsRtcMoscow
 777  021d ae001a        	ldw	x,#_timeAlignment
 778  0220 cd0000        	call	c_lsub
 780  0223 ae0000        	ldw	x,#L42
 781  0226 cd0000        	call	c_ludv
 783  0229 ae0004        	ldw	x,#L62
 784  022c cd0000        	call	c_lumd
 786  022f be02          	ldw	x,c_lreg+2
 787  0231 1f14          	ldw	(OFST-1,sp),x
 789                     ; 135 		oled_print_XXnumber(i%100, 82, 1);
 791  0233 4b01          	push	#1
 792  0235 4b52          	push	#82
 793  0237 1e16          	ldw	x,(OFST+1,sp)
 794  0239 a664          	ld	a,#100
 795  023b cd0000        	call	c_smodx
 797  023e cd0000        	call	_oled_print_XXnumber
 799  0241 85            	popw	x
 800                     ; 136 		i/=100;
 802  0242 1e14          	ldw	x,(OFST-1,sp)
 803  0244 a664          	ld	a,#100
 804  0246 cd0000        	call	c_sdivx
 806  0249 1f14          	ldw	(OFST-1,sp),x
 808                     ; 137 		oled_print_XXnumber(i, 50, 1);
 810  024b 4b01          	push	#1
 811  024d 4b32          	push	#50
 812  024f 1e16          	ldw	x,(OFST+1,sp)
 813  0251 cd0000        	call	_oled_print_XXnumber
 815  0254 85            	popw	x
 816                     ; 133 	while(encoder.but_data == 0) {
 818  0255 3d61          	tnz	_encoder+12
 819  0257 27c1          	jreq	L351
 820                     ; 140 	encoder.but_data = 0;
 822  0259 3f61          	clr	_encoder+12
 823                     ; 141 }
 826  025b 5b15          	addw	sp,#21
 827  025d 81            	ret
 872                     ; 143 int scan_value_at_pos(char pos) {
 873                     	switch	.text
 874  025e               _scan_value_at_pos:
 876  025e 88            	push	a
 877  025f 88            	push	a
 878       00000001      OFST:	set	1
 881  0260 2018          	jra	L502
 882  0262               L302:
 883                     ; 146 		blinking = (encoder.transient_counter >> 10) & 1;
 885  0262 be65          	ldw	x,_encoder+16
 886  0264 4f            	clr	a
 887  0265 01            	rrwa	x,a
 888  0266 54            	srlw	x
 889  0267 54            	srlw	x
 890  0268 01            	rrwa	x,a
 891  0269 a401          	and	a,#1
 892  026b 5f            	clrw	x
 893  026c 6b01          	ld	(OFST+0,sp),a
 895                     ; 147 		oled_print_XXnumber(encoder.enc_data, pos, blinking);
 897  026e 7b01          	ld	a,(OFST+0,sp)
 898  0270 88            	push	a
 899  0271 7b03          	ld	a,(OFST+2,sp)
 900  0273 88            	push	a
 901  0274 be5b          	ldw	x,_encoder+6
 902  0276 cd0000        	call	_oled_print_XXnumber
 904  0279 85            	popw	x
 905  027a               L502:
 906                     ; 145 	while(encoder.but_data == 0) {
 908  027a 3d61          	tnz	_encoder+12
 909  027c 27e4          	jreq	L302
 910                     ; 149 	encoder.but_data = 0;
 912  027e 3f61          	clr	_encoder+12
 913                     ; 150 	return encoder.enc_data;
 915  0280 be5b          	ldw	x,_encoder+6
 918  0282 5b02          	addw	sp,#2
 919  0284 81            	ret
 947                     ; 153 void saveTimeCorrectionToEeprom() { 
 948                     	switch	.text
 949  0285               _saveTimeCorrectionToEeprom:
 953                     ; 155 	sim();
 956  0285 9b            sim
 958                     ; 156   if (!((FLASH->IAPSR) & (FLASH_IAPSR_DUL))) {  // unlock EEPROM
 961  0286 c6505f        	ld	a,20575
 962  0289 a508          	bcp	a,#8
 963  028b 2608          	jrne	L122
 964                     ; 157        FLASH->DUKR = 0xAE;
 966  028d 35ae5064      	mov	20580,#174
 967                     ; 158        FLASH->DUKR = 0x56;
 969  0291 35565064      	mov	20580,#86
 970  0295               L122:
 971                     ; 160   rim();
 974  0295 9a            rim
 978  0296               L522:
 979                     ; 161   while (!((FLASH->IAPSR) & (FLASH_IAPSR_DUL))) ;
 981  0296 c6505f        	ld	a,20575
 982  0299 a508          	bcp	a,#8
 983  029b 27f9          	jreq	L522
 984                     ; 163   eeprom_data.timeCorrSec = timeAlignment.timeCorrSec;
 986  029d 5500224104    	mov	_eeprom_data+4,_timeAlignment+8
 987                     ; 164   eeprom_data.timeCorrDecaMs = timeAlignment.timeCorrDecaMs;
 989  02a2 5500244105    	mov	_eeprom_data+5,_timeAlignment+10
 990                     ; 165   eeprom_data.positiveCorr = timeAlignment.positiveCorr;
 992  02a7 5500234106    	mov	_eeprom_data+6,_timeAlignment+9
 993                     ; 167   FLASH->IAPSR &= ~(FLASH_IAPSR_DUL);  // lock EEPROM
 995  02ac 7217505f      	bres	20575,#3
 996                     ; 168 }  
 999  02b0 81            	ret
1038                     ; 170 void saveFirstPointTimeToEeprom() { 
1039                     	switch	.text
1040  02b1               _saveFirstPointTimeToEeprom:
1042  02b1 88            	push	a
1043       00000001      OFST:	set	1
1046                     ; 172 	sim();
1049  02b2 9b            sim
1051                     ; 173   if (!((FLASH->IAPSR) & (FLASH_IAPSR_DUL))) {  // unlock EEPROM
1054  02b3 c6505f        	ld	a,20575
1055  02b6 a508          	bcp	a,#8
1056  02b8 2608          	jrne	L742
1057                     ; 174        FLASH->DUKR = 0xAE;
1059  02ba 35ae5064      	mov	20580,#174
1060                     ; 175        FLASH->DUKR = 0x56;
1062  02be 35565064      	mov	20580,#86
1063  02c2               L742:
1064                     ; 177   rim();
1067  02c2 9a            rim
1071  02c3               L352:
1072                     ; 178   while (!((FLASH->IAPSR) & (FLASH_IAPSR_DUL))) ;
1074  02c3 c6505f        	ld	a,20575
1075  02c6 a508          	bcp	a,#8
1076  02c8 27f9          	jreq	L352
1077                     ; 180   for(i =0; i<4; i++) {
1079  02ca 0f01          	clr	(OFST+0,sp)
1081  02cc               L752:
1082                     ; 181     eeprom_data.epochSecFirstPoint[i] =  (timeAlignment.epochSecFirstPoint >> (i * 8)) & 0xFF;
1084  02cc ae001a        	ldw	x,#_timeAlignment
1085  02cf cd0000        	call	c_ltor
1087  02d2 7b01          	ld	a,(OFST+0,sp)
1088  02d4 48            	sll	a
1089  02d5 48            	sll	a
1090  02d6 48            	sll	a
1091  02d7 cd0000        	call	c_lursh
1093  02da 3f02          	clr	c_lreg+2
1094  02dc 3f01          	clr	c_lreg+1
1095  02de 3f00          	clr	c_lreg
1096  02e0 7b01          	ld	a,(OFST+0,sp)
1097  02e2 5f            	clrw	x
1098  02e3 97            	ld	xl,a
1099  02e4 b603          	ld	a,c_lreg+3
1100  02e6 d74100        	ld	(_eeprom_data,x),a
1101                     ; 180   for(i =0; i<4; i++) {
1103  02e9 0c01          	inc	(OFST+0,sp)
1107  02eb 7b01          	ld	a,(OFST+0,sp)
1108  02ed a104          	cp	a,#4
1109  02ef 25db          	jrult	L752
1110                     ; 184   FLASH->IAPSR &= ~(FLASH_IAPSR_DUL);  // lock EEPROM
1112  02f1 7217505f      	bres	20575,#3
1113                     ; 185 }  
1116  02f5 84            	pop	a
1117  02f6 81            	ret
1154                     ; 187 void populate_timeAlignment_from_eeprom() { 
1155                     	switch	.text
1156  02f7               _populate_timeAlignment_from_eeprom:
1158  02f7 88            	push	a
1159       00000001      OFST:	set	1
1162                     ; 189   for(i = 0; i<4; i++) {
1164  02f8 0f01          	clr	(OFST+0,sp)
1166  02fa               L303:
1167                     ; 190      timeAlignment.epochSecFirstPoint |=  ((unsigned long) eeprom_data.epochSecFirstPoint[i]) << (i * 8);
1169  02fa 7b01          	ld	a,(OFST+0,sp)
1170  02fc 5f            	clrw	x
1171  02fd 97            	ld	xl,a
1172  02fe d64100        	ld	a,(_eeprom_data,x)
1173  0301 b703          	ld	c_lreg+3,a
1174  0303 3f02          	clr	c_lreg+2
1175  0305 3f01          	clr	c_lreg+1
1176  0307 3f00          	clr	c_lreg
1177  0309 7b01          	ld	a,(OFST+0,sp)
1178  030b 48            	sll	a
1179  030c 48            	sll	a
1180  030d 48            	sll	a
1181  030e cd0000        	call	c_llsh
1183  0311 ae001a        	ldw	x,#_timeAlignment
1184  0314 cd0000        	call	c_lgor
1186                     ; 189   for(i = 0; i<4; i++) {
1188  0317 0c01          	inc	(OFST+0,sp)
1192  0319 7b01          	ld	a,(OFST+0,sp)
1193  031b a104          	cp	a,#4
1194  031d 25db          	jrult	L303
1195                     ; 192   timeAlignment.timeCorrSec = eeprom_data.timeCorrSec;
1197  031f 5541040022    	mov	_timeAlignment+8,_eeprom_data+4
1198                     ; 193   timeAlignment.timeCorrDecaMs = eeprom_data.timeCorrDecaMs;
1200  0324 5541050024    	mov	_timeAlignment+10,_eeprom_data+5
1201                     ; 194   timeAlignment.positiveCorr = eeprom_data.positiveCorr;
1203  0329 5541060023    	mov	_timeAlignment+9,_eeprom_data+6
1204                     ; 195 } 
1207  032e 84            	pop	a
1208  032f 81            	ret
1696                     	xdef	_main
1697                     	switch	.ubsct
1698  0000               _oledBuffer:
1699  0000 000000000000  	ds.b	26
1700                     	xdef	_oledBuffer
1701  001a               _timeAlignment:
1702  001a 000000000000  	ds.b	12
1703                     	xdef	_timeAlignment
1704  0026               _dateFromEpochDaysCache:
1705  0026 000000000000  	ds.b	6
1706                     	xdef	_dateFromEpochDaysCache
1707  002c               _secondsRtcUtcCache:
1708  002c 000000000000  	ds.b	17
1709                     	xdef	_secondsRtcUtcCache
1710  003d               _timeTransferBodyCache:
1711  003d 000000000000  	ds.b	9
1712                     	xdef	_timeTransferBodyCache
1713  0046               _transferBody:
1714  0046 000000000000  	ds.b	6
1715                     	xdef	_transferBody
1716  004c               _alignmentTimeCache:
1717  004c 000000000000  	ds.b	9
1718                     	xdef	_alignmentTimeCache
1719  0055               _encoder:
1720  0055 000000000000  	ds.b	18
1721                     	xdef	_encoder
1722                     	xref	_print_save
1723                     	xref	_print_time
1724                     	xref	_oled_print_XXnumber
1725                     	xref	_oled_print_giga_char
1726                     	xref	_oled_Clear_Screen
1727                     	xref	_init_ssd1306
1728                     	xref	_i2c_wr_reg
1729                     	xref	_init_iic_emb_tx
1730                     	xref	_encoder_setter
1731                     	xref	_init_encoder
1732                     	xdef	_scan_value_at_pos
1733                     	xdef	_menu_selector
1734                     	xdef	_saveFirstPointTimeToEeprom
1735                     	xdef	_saveTimeCorrectionToEeprom
1736                     	xdef	_populate_timeAlignment_from_eeprom
1737                     	xref	_refreshTimeTransferBody
1738                     	xref	_receiveEpochSecondsRtcMoscow
1739                     	xref	_init_rtc
1740                     	xref	_rtc_set_time_date
1741                     	xref.b	c_lreg
1742                     	xref.b	c_x
1762                     	xref	c_lgor
1763                     	xref	c_llsh
1764                     	xref	c_lursh
1765                     	xref	c_ltor
1766                     	xref	c_sdivx
1767                     	xref	c_smodx
1768                     	xref	c_lumd
1769                     	xref	c_ludv
1770                     	xref	c_lsub
1771                     	xref	c_rtol
1772                     	end
