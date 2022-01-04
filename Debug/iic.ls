   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.5 - 16 Jun 2021
   3                     ; Generator (Limited) V4.5.3 - 16 Jun 2021
  74                     ; 5 char get_addresses_iic( char n )
  74                     ; 6 {
  76                     	switch	.text
  77  0000               _get_addresses_iic:
  79  0000 89            	pushw	x
  80       00000002      OFST:	set	2
  83                     ; 7   char count_addr=0;
  85  0001 0f01          	clr	(OFST-1,sp)
  87                     ; 9   for (i=1;i<128;i++)
  89  0003 a601          	ld	a,#1
  90  0005 6b02          	ld	(OFST+0,sp),a
  92  0007               L73:
  93                     ; 11    if(!start_iic(i,WRITE))
  95  0007 7b02          	ld	a,(OFST+0,sp)
  96  0009 5f            	clrw	x
  97  000a 95            	ld	xh,a
  98  000b ad25          	call	_start_iic
 100  000d 4d            	tnz	a
 101  000e 2605          	jrne	L54
 102                     ; 12    {stop_iic();
 104  0010 cd0130        	call	_stop_iic
 106                     ; 13    count_addr++;}
 108  0013 0c01          	inc	(OFST-1,sp)
 110  0015               L54:
 111                     ; 9   for (i=1;i<128;i++)
 113  0015 0c02          	inc	(OFST+0,sp)
 117  0017 7b02          	ld	a,(OFST+0,sp)
 118  0019 a180          	cp	a,#128
 119  001b 25ea          	jrult	L73
 120                     ; 15   return count_addr;
 122  001d 7b01          	ld	a,(OFST-1,sp)
 125  001f 85            	popw	x
 126  0020 81            	ret
 170                     ; 18 void sys_del_us(char del_us)	
 170                     ; 19 {
 171                     	switch	.text
 172  0021               _sys_del_us:
 174  0021 88            	push	a
 175  0022 88            	push	a
 176       00000001      OFST:	set	1
 179                     ; 21 for(i=0;i<del_us;i++)
 181  0023 0f01          	clr	(OFST+0,sp)
 184  0025 2003          	jra	L57
 185  0027               L17:
 186                     ; 22 {nop();}
 189  0027 9d            nop
 191                     ; 21 for(i=0;i<del_us;i++)
 194  0028 0c01          	inc	(OFST+0,sp)
 196  002a               L57:
 199  002a 7b01          	ld	a,(OFST+0,sp)
 200  002c 1102          	cp	a,(OFST+1,sp)
 201  002e 25f7          	jrult	L17
 202                     ; 23 }
 205  0030 85            	popw	x
 206  0031 81            	ret
 251                     ; 25 char start_iic (char adr_iic, char read_write_bit)
 251                     ; 26 {
 252                     	switch	.text
 253  0032               _start_iic:
 255  0032 89            	pushw	x
 256       00000000      OFST:	set	0
 259                     ; 28 	GPIOB->CR2&=~BIT_clk; //PA_clk_pin  - low speed (interrupt disabled)
 261  0033 72195009      	bres	20489,#4
 262                     ; 29 	GPIOB->CR1&=~BIT_clk; //PA_clk_pin  - open drain /float in inp. direct
 264  0037 72195008      	bres	20488,#4
 265                     ; 30 	GPIOB->ODR|=BIT_clk; //PA_clk_pin  - 1 (CLOCK)
 267  003b 72185005      	bset	20485,#4
 268                     ; 31 	GPIOB->DDR|=BIT_clk; 
 270  003f 72185007      	bset	20487,#4
 271                     ; 32 	GPIOB->CR2&=~BIT_sda; //PA_sda_pin  - low speed (interrupt disabled)
 273  0043 721b5009      	bres	20489,#5
 274                     ; 33 	GPIOB->CR1&=~BIT_sda; //PA_sda_pin - open drain /float in inp. direct
 276  0047 721b5008      	bres	20488,#5
 277                     ; 34 	GPIOB->ODR|=BIT_sda; //PA_sda_pin  - 1 (SDA)
 279  004b 721a5005      	bset	20485,#5
 280                     ; 35 	GPIOB->DDR|=BIT_sda; 
 282  004f 721a5007      	bset	20487,#5
 283                     ; 38 	GPIOB->ODR&=~BIT_sda; 											//set sda=0
 285  0053 721b5005      	bres	20485,#5
 286                     ; 39 	nop();//>0.1us
 289  0057 9d            nop
 291                     ; 40 	return send_byte ((adr_iic<<1)+read_write_bit);
 294  0058 9e            	ld	a,xh
 295  0059 48            	sll	a
 296  005a 1b02          	add	a,(OFST+2,sp)
 297  005c ad02          	call	_send_byte
 301  005e 85            	popw	x
 302  005f 81            	ret
 346                     ; 43 char send_byte (char data_byte)
 346                     ; 44 {
 347                     	switch	.text
 348  0060               _send_byte:
 350  0060 88            	push	a
 351  0061 88            	push	a
 352       00000001      OFST:	set	1
 355                     ; 47 	for(i=8;i>0;i--)
 357  0062 a608          	ld	a,#8
 358  0064 6b01          	ld	(OFST+0,sp),a
 360  0066               L541:
 361                     ; 49 	 GPIOB->ODR&=~BIT_clk;//clock=0
 363  0066 72195005      	bres	20485,#4
 364                     ; 50          GPIOB->ODR&=~BIT_sda;//set data=0
 366  006a 721b5005      	bres	20485,#5
 367                     ; 51 	 sys_del_us(2);//>2us
 369  006e a602          	ld	a,#2
 370  0070 adaf          	call	_sys_del_us
 372                     ; 52 	 GPIOB->ODR|=((data_byte>>(i-1))&1)<<PIN_sda;//set data
 374  0072 7b01          	ld	a,(OFST+0,sp)
 375  0074 4a            	dec	a
 376  0075 5f            	clrw	x
 377  0076 97            	ld	xl,a
 378  0077 7b02          	ld	a,(OFST+1,sp)
 379  0079 5d            	tnzw	x
 380  007a 2704          	jreq	L41
 381  007c               L61:
 382  007c 44            	srl	a
 383  007d 5a            	decw	x
 384  007e 26fc          	jrne	L61
 385  0080               L41:
 386  0080 a401          	and	a,#1
 387  0082 97            	ld	xl,a
 388  0083 a620          	ld	a,#32
 389  0085 42            	mul	x,a
 390  0086 9f            	ld	a,xl
 391  0087 ca5005        	or	a,20485
 392  008a c75005        	ld	20485,a
 393                     ; 53 	 sys_del_us(1); //>0.1us
 395  008d a601          	ld	a,#1
 396  008f ad90          	call	_sys_del_us
 398                     ; 54 	 GPIOB->ODR|=BIT_clk;//clock=1
 400  0091 72185005      	bset	20485,#4
 401                     ; 55 	 sys_del_us(1);//>1us
 403  0095 a601          	ld	a,#1
 404  0097 ad88          	call	_sys_del_us
 406                     ; 47 	for(i=8;i>0;i--)
 408  0099 0a01          	dec	(OFST+0,sp)
 412  009b 0d01          	tnz	(OFST+0,sp)
 413  009d 26c7          	jrne	L541
 414                     ; 58 	GPIOB->ODR&=~BIT_clk;											//clock=0
 416  009f 72195005      	bres	20485,#4
 417                     ; 59 	sys_del_us(2);//>2us
 419  00a3 a602          	ld	a,#2
 420  00a5 cd0021        	call	_sys_del_us
 422                     ; 60 	GPIOB->ODR|=BIT_sda;                     //set data=1
 424  00a8 721a5005      	bset	20485,#5
 425                     ; 61 	sys_del_us(1);//>0.1us
 427  00ac a601          	ld	a,#1
 428  00ae cd0021        	call	_sys_del_us
 430                     ; 62 	GPIOB->ODR|=BIT_clk;											//clock=1
 432  00b1 72185005      	bset	20485,#4
 433                     ; 63 	 sys_del_us(1);//>1us
 435  00b5 a601          	ld	a,#1
 436  00b7 cd0021        	call	_sys_del_us
 438                     ; 64 	if ((GPIOB->IDR&BIT_sda)==0) 
 440  00ba c65006        	ld	a,20486
 441  00bd a520          	bcp	a,#32
 442  00bf 2603          	jrne	L351
 443                     ; 65 	return ACK; 
 445  00c1 4f            	clr	a
 447  00c2 2002          	jra	L02
 448  00c4               L351:
 449                     ; 67 	return NOT_ACK;
 451  00c4 a601          	ld	a,#1
 453  00c6               L02:
 455  00c6 85            	popw	x
 456  00c7 81            	ret
 509                     ; 70 unsigned char receive_byte (char acknowledge)
 509                     ; 71 {
 510                     	switch	.text
 511  00c8               _receive_byte:
 513  00c8 88            	push	a
 514  00c9 89            	pushw	x
 515       00000002      OFST:	set	2
 518                     ; 74 	char receive_b=0;
 520  00ca 0f01          	clr	(OFST-1,sp)
 522                     ; 75 	for(i=8;i>0;i--)
 524  00cc a608          	ld	a,#8
 525  00ce 6b02          	ld	(OFST+0,sp),a
 527  00d0               L502:
 528                     ; 77 	 GPIOB->ODR&=~BIT_clk;											//clock=0
 530  00d0 72195005      	bres	20485,#4
 531                     ; 78 	 sys_del_us(4);//>5us
 533  00d4 a604          	ld	a,#4
 534  00d6 cd0021        	call	_sys_del_us
 536                     ; 79 	 GPIOB->ODR|=BIT_clk;											//clock=1
 538  00d9 72185005      	bset	20485,#4
 539                     ; 80 	 sys_del_us(4);//>5us
 541  00dd a604          	ld	a,#4
 542  00df cd0021        	call	_sys_del_us
 544                     ; 81 	 GPIOB->DDR&=~BIT_sda;
 546  00e2 721b5007      	bres	20487,#5
 547                     ; 82 	 receive_b|=(((GPIOB->IDR)&BIT_sda)>>PIN_sda)<<(i-1);
 549  00e6 7b02          	ld	a,(OFST+0,sp)
 550  00e8 4a            	dec	a
 551  00e9 5f            	clrw	x
 552  00ea 97            	ld	xl,a
 553  00eb c65006        	ld	a,20486
 554  00ee 4e            	swap	a
 555  00ef 44            	srl	a
 556  00f0 a407          	and	a,#7
 557  00f2 a401          	and	a,#1
 558  00f4 5d            	tnzw	x
 559  00f5 2704          	jreq	L42
 560  00f7               L62:
 561  00f7 48            	sll	a
 562  00f8 5a            	decw	x
 563  00f9 26fc          	jrne	L62
 564  00fb               L42:
 565  00fb 1a01          	or	a,(OFST-1,sp)
 566  00fd 6b01          	ld	(OFST-1,sp),a
 568                     ; 83 	 GPIOB->DDR|=BIT_sda;
 570  00ff 721a5007      	bset	20487,#5
 571                     ; 75 	for(i=8;i>0;i--)
 573  0103 0a02          	dec	(OFST+0,sp)
 577  0105 0d02          	tnz	(OFST+0,sp)
 578  0107 26c7          	jrne	L502
 579                     ; 86 	GPIOB->ODR&=~BIT_clk;										//clock=0
 581  0109 72195005      	bres	20485,#4
 582                     ; 87 	if(acknowledge) GPIOB->ODR&=~BIT_sda;     //set data=0	
 584  010d 0d03          	tnz	(OFST+1,sp)
 585  010f 2704          	jreq	L312
 588  0111 721b5005      	bres	20485,#5
 589  0115               L312:
 590                     ; 88 	sys_del_us(2);//>2us
 592  0115 a602          	ld	a,#2
 593  0117 cd0021        	call	_sys_del_us
 595                     ; 89 	GPIOB->ODR|=BIT_clk;											//clock=1
 597  011a 72185005      	bset	20485,#4
 598                     ; 90 	sys_del_us(2);//>1us
 600  011e a602          	ld	a,#2
 601  0120 cd0021        	call	_sys_del_us
 603                     ; 91 	GPIOB->ODR&=~BIT_clk;											//clock=0
 605  0123 72195005      	bres	20485,#4
 606                     ; 92 	GPIOB->ODR|=BIT_sda; 
 608  0127 721a5005      	bset	20485,#5
 609                     ; 94 	return receive_b;
 611  012b 7b01          	ld	a,(OFST-1,sp)
 614  012d 5b03          	addw	sp,#3
 615  012f 81            	ret
 641                     ; 97 void stop_iic (void)
 641                     ; 98 {	 
 642                     	switch	.text
 643  0130               _stop_iic:
 647                     ; 99   GPIOB->ODR&=~BIT_clk;											//clock=0
 649  0130 72195005      	bres	20485,#4
 650                     ; 100 	sys_del_us(2);//>2us
 652  0134 a602          	ld	a,#2
 653  0136 cd0021        	call	_sys_del_us
 655                     ; 101 	GPIOB->ODR&=~BIT_sda; 											//set sda=0
 657  0139 721b5005      	bres	20485,#5
 658                     ; 102 	nop(); //>0.1us
 661  013d 9d            nop
 663                     ; 103 	GPIOB->ODR|=BIT_clk;											//clock=1
 666  013e 72185005      	bset	20485,#4
 667                     ; 104 	nop();//>0.1us
 670  0142 9d            nop
 672                     ; 105 	GPIOB->ODR|=BIT_sda; 											//set sda=1
 675  0143 721a5005      	bset	20485,#5
 676                     ; 106 }
 679  0147 81            	ret
 692                     	xdef	_get_addresses_iic
 693                     	xdef	_stop_iic
 694                     	xdef	_receive_byte
 695                     	xdef	_send_byte
 696                     	xdef	_start_iic
 697                     	xdef	_sys_del_us
 716                     	end
