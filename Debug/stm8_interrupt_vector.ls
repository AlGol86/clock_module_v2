   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.5 - 16 Jun 2021
   3                     ; Generator (Limited) V4.5.3 - 16 Jun 2021
  45                     ; 14 @far @interrupt void NonHandledInterrupt (void)
  45                     ; 15 {
  46                     	switch	.text
  47  0000               f_NonHandledInterrupt:
  51                     ; 19 	return;
  54  0000 80            	iret
  56                     	xref.b	_encoder
  78                     ; 22 @far @interrupt void TIM2Interrupt (void)
  78                     ; 23 {
  79                     	switch	.text
  80  0001               f_TIM2Interrupt:
  82  0001 8a            	push	cc
  83  0002 84            	pop	a
  84  0003 a4bf          	and	a,#191
  85  0005 88            	push	a
  86  0006 86            	pop	cc
  87  0007 3b0002        	push	c_x+2
  88  000a be00          	ldw	x,c_x
  89  000c 89            	pushw	x
  90  000d 3b0002        	push	c_y+2
  91  0010 be00          	ldw	x,c_y
  92  0012 89            	pushw	x
  95                     ; 26 	TIM2->SR1&=~TIM2_SR1_UIF;//flag "0"
  97  0013 72115304      	bres	21252,#0
  98                     ; 27 	encoder_handler(&encoder);
 100  0017 ae0000        	ldw	x,#_encoder
 101  001a cd0000        	call	_encoder_handler
 103                     ; 28 	encoder.transient_counter++;
 105  001d be10          	ldw	x,_encoder+16
 106  001f 1c0001        	addw	x,#1
 107  0022 bf10          	ldw	_encoder+16,x
 108                     ; 29 	return;
 111  0024 85            	popw	x
 112  0025 bf00          	ldw	c_y,x
 113  0027 320002        	pop	c_y+2
 114  002a 85            	popw	x
 115  002b bf00          	ldw	c_x,x
 116  002d 320002        	pop	c_x+2
 117  0030 80            	iret
 119                     .const:	section	.text
 120  0000               __vectab:
 121  0000 82            	dc.b	130
 123  0001 00            	dc.b	page(__stext)
 124  0002 0000          	dc.w	__stext
 125  0004 82            	dc.b	130
 127  0005 00            	dc.b	page(f_NonHandledInterrupt)
 128  0006 0000          	dc.w	f_NonHandledInterrupt
 129  0008 82            	dc.b	130
 131  0009 00            	dc.b	page(f_NonHandledInterrupt)
 132  000a 0000          	dc.w	f_NonHandledInterrupt
 133  000c 82            	dc.b	130
 135  000d 00            	dc.b	page(f_NonHandledInterrupt)
 136  000e 0000          	dc.w	f_NonHandledInterrupt
 137  0010 82            	dc.b	130
 139  0011 00            	dc.b	page(f_NonHandledInterrupt)
 140  0012 0000          	dc.w	f_NonHandledInterrupt
 141  0014 82            	dc.b	130
 143  0015 00            	dc.b	page(f_NonHandledInterrupt)
 144  0016 0000          	dc.w	f_NonHandledInterrupt
 145  0018 82            	dc.b	130
 147  0019 00            	dc.b	page(f_NonHandledInterrupt)
 148  001a 0000          	dc.w	f_NonHandledInterrupt
 149  001c 82            	dc.b	130
 151  001d 00            	dc.b	page(f_NonHandledInterrupt)
 152  001e 0000          	dc.w	f_NonHandledInterrupt
 153  0020 82            	dc.b	130
 155  0021 00            	dc.b	page(f_NonHandledInterrupt)
 156  0022 0000          	dc.w	f_NonHandledInterrupt
 157  0024 82            	dc.b	130
 159  0025 00            	dc.b	page(f_NonHandledInterrupt)
 160  0026 0000          	dc.w	f_NonHandledInterrupt
 161  0028 82            	dc.b	130
 163  0029 00            	dc.b	page(f_NonHandledInterrupt)
 164  002a 0000          	dc.w	f_NonHandledInterrupt
 165  002c 82            	dc.b	130
 167  002d 00            	dc.b	page(f_NonHandledInterrupt)
 168  002e 0000          	dc.w	f_NonHandledInterrupt
 169  0030 82            	dc.b	130
 171  0031 00            	dc.b	page(f_NonHandledInterrupt)
 172  0032 0000          	dc.w	f_NonHandledInterrupt
 173  0034 82            	dc.b	130
 175  0035 00            	dc.b	page(f_NonHandledInterrupt)
 176  0036 0000          	dc.w	f_NonHandledInterrupt
 177  0038 82            	dc.b	130
 179  0039 00            	dc.b	page(f_NonHandledInterrupt)
 180  003a 0000          	dc.w	f_NonHandledInterrupt
 181  003c 82            	dc.b	130
 183  003d 01            	dc.b	page(f_TIM2Interrupt)
 184  003e 0001          	dc.w	f_TIM2Interrupt
 185  0040 82            	dc.b	130
 187  0041 00            	dc.b	page(f_NonHandledInterrupt)
 188  0042 0000          	dc.w	f_NonHandledInterrupt
 189  0044 82            	dc.b	130
 191  0045 00            	dc.b	page(f_NonHandledInterrupt)
 192  0046 0000          	dc.w	f_NonHandledInterrupt
 193  0048 82            	dc.b	130
 195  0049 00            	dc.b	page(f_NonHandledInterrupt)
 196  004a 0000          	dc.w	f_NonHandledInterrupt
 197  004c 82            	dc.b	130
 199  004d 00            	dc.b	page(f_NonHandledInterrupt)
 200  004e 0000          	dc.w	f_NonHandledInterrupt
 201  0050 82            	dc.b	130
 203  0051 00            	dc.b	page(f_NonHandledInterrupt)
 204  0052 0000          	dc.w	f_NonHandledInterrupt
 205  0054 82            	dc.b	130
 207  0055 00            	dc.b	page(f_NonHandledInterrupt)
 208  0056 0000          	dc.w	f_NonHandledInterrupt
 209  0058 82            	dc.b	130
 211  0059 00            	dc.b	page(f_NonHandledInterrupt)
 212  005a 0000          	dc.w	f_NonHandledInterrupt
 213  005c 82            	dc.b	130
 215  005d 00            	dc.b	page(f_NonHandledInterrupt)
 216  005e 0000          	dc.w	f_NonHandledInterrupt
 217  0060 82            	dc.b	130
 219  0061 00            	dc.b	page(f_NonHandledInterrupt)
 220  0062 0000          	dc.w	f_NonHandledInterrupt
 221  0064 82            	dc.b	130
 223  0065 00            	dc.b	page(f_NonHandledInterrupt)
 224  0066 0000          	dc.w	f_NonHandledInterrupt
 225  0068 82            	dc.b	130
 227  0069 00            	dc.b	page(f_NonHandledInterrupt)
 228  006a 0000          	dc.w	f_NonHandledInterrupt
 229  006c 82            	dc.b	130
 231  006d 00            	dc.b	page(f_NonHandledInterrupt)
 232  006e 0000          	dc.w	f_NonHandledInterrupt
 233  0070 82            	dc.b	130
 235  0071 00            	dc.b	page(f_NonHandledInterrupt)
 236  0072 0000          	dc.w	f_NonHandledInterrupt
 237  0074 82            	dc.b	130
 239  0075 00            	dc.b	page(f_NonHandledInterrupt)
 240  0076 0000          	dc.w	f_NonHandledInterrupt
 241  0078 82            	dc.b	130
 243  0079 00            	dc.b	page(f_NonHandledInterrupt)
 244  007a 0000          	dc.w	f_NonHandledInterrupt
 245  007c 82            	dc.b	130
 247  007d 00            	dc.b	page(f_NonHandledInterrupt)
 248  007e 0000          	dc.w	f_NonHandledInterrupt
 299                     	xdef	__vectab
 300                     	xref	__stext
 301                     	xdef	f_NonHandledInterrupt
 302                     	xref	_encoder_handler
 303                     	xdef	f_TIM2Interrupt
 304                     	xref.b	c_x
 305                     	xref.b	c_y
 324                     	end
