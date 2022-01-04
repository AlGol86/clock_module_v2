   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.5 - 16 Jun 2021
   3                     ; Generator (Limited) V4.5.3 - 16 Jun 2021
  43                     ; 7 void init_iic_emb_tx(){
  45                     	switch	.text
  46  0000               _init_iic_emb_tx:
  50                     ; 8         I2C->CR2 &= ~I2C_CR2_SWRST; 
  52  0000 721f5211      	bres	21009,#7
  53                     ; 9         I2C->CR1 &= ~I2C_CR1_PE; 
  55  0004 72115210      	bres	21008,#0
  56                     ; 10         I2C->OARH |= I2C_OARH_ADDCONF;
  58  0008 721c5214      	bset	21012,#6
  59                     ; 11         I2C->FREQR  |= 2; //Master f (2MHz by default)
  61  000c 72125212      	bset	21010,#1
  62                     ; 12         I2C->TRISER |= 3; //= I2C->FREQR_FREQ + 1
  64  0010 c6521d        	ld	a,21021
  65  0013 aa03          	or	a,#3
  66  0015 c7521d        	ld	21021,a
  67                     ; 13         I2C->CCRL = 30; // for fMaster = 2MHZ -> ~ >= 10 (4 still works) def 20
  69  0018 351e521b      	mov	21019,#30
  70                     ; 14         I2C->CCRH = 0;
  72  001c 725f521c      	clr	21020
  73                     ; 20         I2C->CR1 |= I2C_CR1_PE;
  75  0020 72105210      	bset	21008,#0
  76                     ; 21 				I2C->CR2 |= I2C_CR2_ACK;
  78  0024 72145211      	bset	21009,#2
  79                     ; 22 }
  82  0028 81            	ret
 154                     ; 24 void i2c_wr_reg(char address, char reg_addr, char * data, char length) {  
 155                     	switch	.text
 156  0029               _i2c_wr_reg:
 158  0029 89            	pushw	x
 159  002a 88            	push	a
 160       00000001      OFST:	set	1
 163  002b 2006          	jra	L16
 164  002d               L75:
 165                     ; 27     I2C->CR2|=I2C_CR2_SWRST; 
 167  002d 721e5211      	bset	21009,#7
 168                     ; 28     init_iic_emb_tx();
 170  0031 adcd          	call	_init_iic_emb_tx
 172  0033               L16:
 173                     ; 26   while(I2C->SR3 & I2C_SR3_BUSY){
 175  0033 c65219        	ld	a,21017
 176  0036 a502          	bcp	a,#2
 177  0038 26f3          	jrne	L75
 178                     ; 30   I2C->CR2|=I2C_CR2_START; 
 180  003a 72105211      	bset	21009,#0
 182  003e               L76:
 183                     ; 31   while(!(I2C->SR1 & I2C_SR1_SB));
 185  003e c65217        	ld	a,21015
 186  0041 a501          	bcp	a,#1
 187  0043 27f9          	jreq	L76
 188                     ; 32   I2C->DR = address << 1;
 190  0045 7b02          	ld	a,(OFST+1,sp)
 191  0047 48            	sll	a
 192  0048 c75216        	ld	21014,a
 194  004b 2011          	jra	L77
 195  004d               L37:
 196                     ; 35 	if(I2C->SR2 & I2C_SR2_AF) {
 198  004d c65218        	ld	a,21016
 199  0050 a504          	bcp	a,#4
 200  0052 270a          	jreq	L77
 201                     ; 36   I2C->CR2|=I2C_CR2_STOP; 
 203  0054 72125211      	bset	21009,#1
 204                     ; 37 	I2C->SR2 &= ~I2C_SR2_AF;
 206  0058 72155218      	bres	21016,#2
 207                     ; 38   return;
 209  005c 204a          	jra	L01
 210  005e               L77:
 211                     ; 34   while(!(I2C->SR1 & I2C_SR1_ADDR)){
 213  005e c65217        	ld	a,21015
 214  0061 a502          	bcp	a,#2
 215  0063 27e8          	jreq	L37
 216                     ; 41 	I2C->SR3;
 218  0065 c65219        	ld	a,21017
 219                     ; 43   I2C->DR = reg_addr;
 221  0068 7b03          	ld	a,(OFST+2,sp)
 222  006a c75216        	ld	21014,a
 224  006d 2019          	jra	L111
 225  006f               L711:
 226                     ; 46   while(!(I2C->SR1 & I2C_SR1_TXE));
 228  006f c65217        	ld	a,21015
 229  0072 a580          	bcp	a,#128
 230  0074 27f9          	jreq	L711
 231                     ; 47   c = *data++;
 233  0076 1e06          	ldw	x,(OFST+5,sp)
 234  0078 1c0001        	addw	x,#1
 235  007b 1f06          	ldw	(OFST+5,sp),x
 236  007d 1d0001        	subw	x,#1
 237  0080 f6            	ld	a,(x)
 238  0081 6b01          	ld	(OFST+0,sp),a
 240                     ; 48   I2C->DR = c;
 242  0083 7b01          	ld	a,(OFST+0,sp)
 243  0085 c75216        	ld	21014,a
 244  0088               L111:
 245                     ; 45 while(length--){
 247  0088 7b08          	ld	a,(OFST+7,sp)
 248  008a 0a08          	dec	(OFST+7,sp)
 249  008c 4d            	tnz	a
 250  008d 26e0          	jrne	L711
 252  008f               L521:
 253                     ; 51 while(!((I2C->SR1 & I2C_SR1_TXE) && (I2C->SR1 & I2C_SR1_BTF)));
 255  008f c65217        	ld	a,21015
 256  0092 a580          	bcp	a,#128
 257  0094 27f9          	jreq	L521
 259  0096 c65217        	ld	a,21015
 260  0099 a504          	bcp	a,#4
 261  009b 27f2          	jreq	L521
 262                     ; 52 I2C->CR2|=I2C_CR2_STOP;
 264  009d 72125211      	bset	21009,#1
 266  00a1               L331:
 267                     ; 53 while(I2C->CR2 & I2C_CR2_STOP);
 269  00a1 c65211        	ld	a,21009
 270  00a4 a502          	bcp	a,#2
 271  00a6 26f9          	jrne	L331
 272                     ; 55 }
 273  00a8               L01:
 276  00a8 5b03          	addw	sp,#3
 277  00aa 81            	ret
 290                     	xdef	_i2c_wr_reg
 291                     	xdef	_init_iic_emb_tx
 310                     	end
