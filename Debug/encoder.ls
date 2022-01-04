   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.5 - 16 Jun 2021
   3                     ; Generator (Limited) V4.5.3 - 16 Jun 2021
  44                     ; 5 void init_tim2 (void) {//encoder_poller
  46                     	switch	.text
  47  0000               _init_tim2:
  51                     ; 6   TIM2->IER|=TIM2_IER_UIE;
  53  0000 72105303      	bset	21251,#0
  54                     ; 8   TIM2->PSCR=0;
  56  0004 725f530e      	clr	21262
  57                     ; 9 	TIM2->ARRH=1; //2
  59  0008 3501530f      	mov	21263,#1
  60                     ; 10   TIM2->ARRL=20;//20
  62  000c 35145310      	mov	21264,#20
  63                     ; 11 	TIM2->CNTRH=0;
  65  0010 725f530c      	clr	21260
  66                     ; 12 	TIM2->CNTRL=0;
  68  0014 725f530d      	clr	21261
  69                     ; 13 	rim();
  72  0018 9a            rim
  74                     ; 14 	TIM2->CR1|=TIM2_CR1_CEN;
  77  0019 72105300      	bset	21248,#0
  78                     ; 15   }
  81  001d 81            	ret
 223                     ; 17 void init_encoder(encoder_t* enc){
 224                     	switch	.text
 225  001e               _init_encoder:
 227  001e 89            	pushw	x
 228       00000000      OFST:	set	0
 231                     ; 19 	init_tim2();
 233  001f addf          	call	_init_tim2
 235                     ; 21 	PORT_ENCODER_R_B->CR2&=~(bit_enc_l|bit_enc_r|bit_enc_b);
 237  0021 c6500e        	ld	a,20494
 238  0024 a43b          	and	a,#59
 239  0026 c7500e        	ld	20494,a
 240                     ; 22 	PORT_ENCODER_R_B->DDR&=~(bit_enc_l|bit_enc_r|bit_enc_b);
 242  0029 c6500c        	ld	a,20492
 243  002c a43b          	and	a,#59
 244  002e c7500c        	ld	20492,a
 245                     ; 23 	PORT_ENCODER_R_B->CR1|=(bit_enc_l|bit_enc_r|bit_enc_b);
 247  0031 c6500d        	ld	a,20493
 248  0034 aac4          	or	a,#196
 249  0036 c7500d        	ld	20493,a
 250                     ; 24 	PORT_ENCODER_L->CR2&=~(bit_enc_l|bit_enc_r|bit_enc_b);
 252  0039 c65013        	ld	a,20499
 253  003c a43b          	and	a,#59
 254  003e c75013        	ld	20499,a
 255                     ; 25 	PORT_ENCODER_L->DDR&=~(bit_enc_l|bit_enc_r|bit_enc_b);
 257  0041 c65011        	ld	a,20497
 258  0044 a43b          	and	a,#59
 259  0046 c75011        	ld	20497,a
 260                     ; 26 	PORT_ENCODER_L->CR1|=(bit_enc_l|bit_enc_r|bit_enc_b);
 262  0049 c65012        	ld	a,20498
 263  004c aac4          	or	a,#196
 264  004e c75012        	ld	20498,a
 265                     ; 28   enc->but_data_lim=1;        
 267  0051 1e01          	ldw	x,(OFST+1,sp)
 268  0053 a601          	ld	a,#1
 269  0055 e70e          	ld	(14,x),a
 270                     ; 29   enc->but_data_lim_long=1;
 272  0057 1e01          	ldw	x,(OFST+1,sp)
 273  0059 a601          	ld	a,#1
 274  005b e70f          	ld	(15,x),a
 275                     ; 30 }
 278  005d 85            	popw	x
 279  005e 81            	ret
 317                     ; 32 char check_encoder_button(encoder_t* enc){
 318                     	switch	.text
 319  005f               _check_encoder_button:
 323                     ; 34         if(PORT_ENCODER_R_B->IDR & bit_enc_b) return 0;
 325  005f c6500b        	ld	a,20491
 326  0062 a540          	bcp	a,#64
 327  0064 2702          	jreq	L321
 330  0066 4f            	clr	a
 333  0067 81            	ret
 334  0068               L321:
 335                     ; 35         else return 1;
 337  0068 a601          	ld	a,#1
 340  006a 81            	ret
 395                     ; 39 void encoder_handler(encoder_t* enc){ 
 396                     	switch	.text
 397  006b               _encoder_handler:
 399  006b 89            	pushw	x
 400  006c 5205          	subw	sp,#5
 401       00000005      OFST:	set	5
 404                     ; 40   char cnt_lim=7;
 406                     ; 41 	int cnt_button_lim=10000;
 408                     ; 43 	if(((PORT_ENCODER_L->IDR&bit_enc_l)==0) && (enc->cnt < cnt_lim)) 
 410  006e c65010        	ld	a,20496
 411  0071 a504          	bcp	a,#4
 412  0073 2608          	jrne	L751
 414  0075 f6            	ld	a,(x)
 415  0076 a107          	cp	a,#7
 416  0078 2403          	jruge	L751
 417                     ; 44 	  enc->cnt++;
 419  007a 7c            	inc	(x)
 421  007b 2008          	jra	L161
 422  007d               L751:
 423                     ; 45   else	if (enc->cnt>0) enc->cnt--;
 425  007d 1e06          	ldw	x,(OFST+1,sp)
 426  007f 7d            	tnz	(x)
 427  0080 2703          	jreq	L161
 430  0082 1e06          	ldw	x,(OFST+1,sp)
 431  0084 7a            	dec	(x)
 432  0085               L161:
 433                     ; 47 	if(((PORT_ENCODER_R_B->IDR&bit_enc_b)==0) && (enc->cnt_button < cnt_button_lim)) 
 435  0085 c6500b        	ld	a,20491
 436  0088 a540          	bcp	a,#64
 437  008a 261c          	jrne	L561
 439  008c 9c            	rvf
 440  008d 1e06          	ldw	x,(OFST+1,sp)
 441  008f 9093          	ldw	y,x
 442  0091 90ee01        	ldw	y,(1,y)
 443  0094 90a32710      	cpw	y,#10000
 444  0098 2e0e          	jrsge	L561
 445                     ; 48 	  enc->cnt_button++;
 447  009a 1e06          	ldw	x,(OFST+1,sp)
 448  009c 9093          	ldw	y,x
 449  009e ee01          	ldw	x,(1,x)
 450  00a0 1c0001        	addw	x,#1
 451  00a3 90ef01        	ldw	(1,y),x
 453  00a6 2034          	jra	L761
 454  00a8               L561:
 455                     ; 49   else	if (enc->cnt_button > 0) 
 457  00a8 9c            	rvf
 458  00a9 5f            	clrw	x
 459  00aa 1f01          	ldw	(OFST-4,sp),x
 461  00ac 1e06          	ldw	x,(OFST+1,sp)
 462  00ae 9093          	ldw	y,x
 463  00b0 51            	exgw	x,y
 464  00b1 ee01          	ldw	x,(1,x)
 465  00b3 1301          	cpw	x,(OFST-4,sp)
 466  00b5 51            	exgw	x,y
 467  00b6 2d24          	jrsle	L761
 468                     ; 50 	        if(enc->cnt_button > cnt_lim) 
 470  00b8 9c            	rvf
 471  00b9 1e06          	ldw	x,(OFST+1,sp)
 472  00bb 9093          	ldw	y,x
 473  00bd 90ee01        	ldw	y,(1,y)
 474  00c0 90a30008      	cpw	y,#8
 475  00c4 2f0a          	jrslt	L371
 476                     ; 51 					    enc->cnt_button = cnt_lim; 
 478  00c6 1e06          	ldw	x,(OFST+1,sp)
 479  00c8 90ae0007      	ldw	y,#7
 480  00cc ef01          	ldw	(1,x),y
 482  00ce 200c          	jra	L761
 483  00d0               L371:
 484                     ; 53 					 enc->cnt_button--;
 486  00d0 1e06          	ldw	x,(OFST+1,sp)
 487  00d2 9093          	ldw	y,x
 488  00d4 ee01          	ldw	x,(1,x)
 489  00d6 1d0001        	subw	x,#1
 490  00d9 90ef01        	ldw	(1,y),x
 491  00dc               L761:
 492                     ; 55 	if ((enc->cnt >(cnt_lim-2))&&(enc->f_push==0)) {
 494  00dc 1e06          	ldw	x,(OFST+1,sp)
 495  00de f6            	ld	a,(x)
 496  00df a106          	cp	a,#6
 497  00e1 2550          	jrult	L771
 499  00e3 1e06          	ldw	x,(OFST+1,sp)
 500  00e5 e603          	ld	a,(3,x)
 501  00e7 a501          	bcp	a,#1
 502  00e9 2648          	jrne	L771
 503                     ; 56 		  enc->f_push=1;
 505  00eb 1e06          	ldw	x,(OFST+1,sp)
 506  00ed e603          	ld	a,(3,x)
 507  00ef aa01          	or	a,#1
 508  00f1 e703          	ld	(3,x),a
 509                     ; 57 			if(((PORT_ENCODER_R_B->IDR&bit_enc_r)==0)&&(enc->enc_data < enc->enc_data_lim_h)) enc->enc_data++; 
 511  00f3 c6500b        	ld	a,20491
 512  00f6 a580          	bcp	a,#128
 513  00f8 261a          	jrne	L102
 515  00fa 9c            	rvf
 516  00fb 1e06          	ldw	x,(OFST+1,sp)
 517  00fd 1606          	ldw	y,(OFST+1,sp)
 518  00ff ee06          	ldw	x,(6,x)
 519  0101 90e308        	cpw	x,(8,y)
 520  0104 2e0e          	jrsge	L102
 523  0106 1e06          	ldw	x,(OFST+1,sp)
 524  0108 9093          	ldw	y,x
 525  010a ee06          	ldw	x,(6,x)
 526  010c 1c0001        	addw	x,#1
 527  010f 90ef06        	ldw	(6,y),x
 529  0112 201f          	jra	L771
 530  0114               L102:
 531                     ; 58 			else if(((PORT_ENCODER_R_B->IDR&bit_enc_r)!=0)&&(enc->enc_data > enc->enc_data_lim_l)) enc->enc_data--;
 533  0114 c6500b        	ld	a,20491
 534  0117 a580          	bcp	a,#128
 535  0119 2718          	jreq	L771
 537  011b 9c            	rvf
 538  011c 1e06          	ldw	x,(OFST+1,sp)
 539  011e 1606          	ldw	y,(OFST+1,sp)
 540  0120 ee06          	ldw	x,(6,x)
 541  0122 90e30a        	cpw	x,(10,y)
 542  0125 2d0c          	jrsle	L771
 545  0127 1e06          	ldw	x,(OFST+1,sp)
 546  0129 9093          	ldw	y,x
 547  012b ee06          	ldw	x,(6,x)
 548  012d 1d0001        	subw	x,#1
 549  0130 90ef06        	ldw	(6,y),x
 550  0133               L771:
 551                     ; 60    if ((enc->cnt==0)&&(enc->cnt_button==0))	
 553  0133 1e06          	ldw	x,(OFST+1,sp)
 554  0135 7d            	tnz	(x)
 555  0136 2618          	jrne	L702
 557  0138 1e06          	ldw	x,(OFST+1,sp)
 558  013a e602          	ld	a,(2,x)
 559  013c ea01          	or	a,(1,x)
 560  013e 2610          	jrne	L702
 561                     ; 61 	       {enc->f_push=0;enc->f_long_push=0;}
 563  0140 1e06          	ldw	x,(OFST+1,sp)
 564  0142 e603          	ld	a,(3,x)
 565  0144 a4fe          	and	a,#254
 566  0146 e703          	ld	(3,x),a
 569  0148 1e06          	ldw	x,(OFST+1,sp)
 570  014a e603          	ld	a,(3,x)
 571  014c a4fd          	and	a,#253
 572  014e e703          	ld	(3,x),a
 573  0150               L702:
 574                     ; 64    if ((enc->cnt_button >(cnt_button_lim-2))&&(enc->f_long_push==0)){
 576  0150 9c            	rvf
 577  0151 1e06          	ldw	x,(OFST+1,sp)
 578  0153 9093          	ldw	y,x
 579  0155 90ee01        	ldw	y,(1,y)
 580  0158 90a3270f      	cpw	y,#9999
 581  015c 2f28          	jrslt	L112
 583  015e 1e06          	ldw	x,(OFST+1,sp)
 584  0160 e603          	ld	a,(3,x)
 585  0162 a502          	bcp	a,#2
 586  0164 2620          	jrne	L112
 587                     ; 65 		enc->f_long_push=1;
 589  0166 1e06          	ldw	x,(OFST+1,sp)
 590  0168 e603          	ld	a,(3,x)
 591  016a aa02          	or	a,#2
 592  016c e703          	ld	(3,x),a
 593                     ; 66 		if (enc->but_data_long < enc->but_data_lim_long) enc->but_data_long++;
 595  016e 1e06          	ldw	x,(OFST+1,sp)
 596  0170 e60d          	ld	a,(13,x)
 597  0172 1e06          	ldw	x,(OFST+1,sp)
 598  0174 e10f          	cp	a,(15,x)
 599  0176 2406          	jruge	L312
 602  0178 1e06          	ldw	x,(OFST+1,sp)
 603  017a 6c0d          	inc	(13,x)
 605  017c 2004          	jra	L512
 606  017e               L312:
 607                     ; 67 		else enc->but_data_long=0;
 609  017e 1e06          	ldw	x,(OFST+1,sp)
 610  0180 6f0d          	clr	(13,x)
 611  0182               L512:
 612                     ; 69 		enc->but_data=0;
 614  0182 1e06          	ldw	x,(OFST+1,sp)
 615  0184 6f0c          	clr	(12,x)
 616  0186               L112:
 617                     ; 73 	if ((enc->cnt_button >(cnt_lim-2))&&(enc->f_push==0)) {
 619  0186 9c            	rvf
 620  0187 1e06          	ldw	x,(OFST+1,sp)
 621  0189 9093          	ldw	y,x
 622  018b 90ee01        	ldw	y,(1,y)
 623  018e 90a30006      	cpw	y,#6
 624  0192 2f24          	jrslt	L712
 626  0194 1e06          	ldw	x,(OFST+1,sp)
 627  0196 e603          	ld	a,(3,x)
 628  0198 a501          	bcp	a,#1
 629  019a 261c          	jrne	L712
 630                     ; 74 		enc->f_push=1;
 632  019c 1e06          	ldw	x,(OFST+1,sp)
 633  019e e603          	ld	a,(3,x)
 634  01a0 aa01          	or	a,#1
 635  01a2 e703          	ld	(3,x),a
 636                     ; 75 		if (enc->but_data < enc->but_data_lim) enc->but_data++;
 638  01a4 1e06          	ldw	x,(OFST+1,sp)
 639  01a6 e60c          	ld	a,(12,x)
 640  01a8 1e06          	ldw	x,(OFST+1,sp)
 641  01aa e10e          	cp	a,(14,x)
 642  01ac 2406          	jruge	L122
 645  01ae 1e06          	ldw	x,(OFST+1,sp)
 646  01b0 6c0c          	inc	(12,x)
 648  01b2 2004          	jra	L712
 649  01b4               L122:
 650                     ; 76 		else enc->but_data=0;
 652  01b4 1e06          	ldw	x,(OFST+1,sp)
 653  01b6 6f0c          	clr	(12,x)
 654  01b8               L712:
 655                     ; 79 }
 658  01b8 5b07          	addw	sp,#7
 659  01ba 81            	ret
 662                     	xref.b	_encoder
 712                     ; 81 void encoder_setter(int lim_l,int lim_h,int first_value){
 713                     	switch	.text
 714  01bb               _encoder_setter:
 716  01bb 89            	pushw	x
 717       00000000      OFST:	set	0
 720                     ; 83 		encoder.enc_data_lim_l=lim_l;
 722  01bc bf0a          	ldw	_encoder+10,x
 723                     ; 84 		encoder.enc_data_lim_h=lim_h;
 725  01be 1e05          	ldw	x,(OFST+5,sp)
 726  01c0 bf08          	ldw	_encoder+8,x
 727                     ; 85 		encoder.enc_data=first_value;
 729  01c2 1e07          	ldw	x,(OFST+7,sp)
 730  01c4 bf06          	ldw	_encoder+6,x
 731                     ; 86 }
 734  01c6 85            	popw	x
 735  01c7 81            	ret
 748                     	xdef	_check_encoder_button
 749                     	xdef	_encoder_setter
 750                     	xdef	_encoder_handler
 751                     	xdef	_init_encoder
 752                     	xdef	_init_tim2
 771                     	end
