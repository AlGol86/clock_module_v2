#include "stm8s.h"
#include "iic_embedded_tx.h"

extern char b[100];
extern char i;

void init_iic_emb_tx(){
        I2C->CR2 &= ~I2C_CR2_SWRST; 
        I2C->CR1 &= ~I2C_CR1_PE; 
        I2C->OARH |= I2C_OARH_ADDCONF;
        I2C->FREQR  |= 2; //Master f (2MHz by default)
        I2C->TRISER |= 3; //= I2C->FREQR_FREQ + 1
        I2C->CCRL = 30; // for fMaster = 2MHZ -> ~ >= 10 (4 still works) def 20
        I2C->CCRH = 0;
        
//        I2C->ITR_ITBUFEN = 1;                //  Buffer interrupt enabled.
//        I2C->ITR_ITEVTEN = 1;                //  Event interrupt enabled.
//        I2C->ITR_ITERREN = 1;
        
        I2C->CR1 |= I2C_CR1_PE;
				I2C->CR2 |= I2C_CR2_ACK;
}

void i2c_wr_reg(char address, char reg_addr, char * data, char length) {  
  char c;
  while(I2C->SR3 & I2C_SR3_BUSY){
    I2C->CR2|=I2C_CR2_SWRST; 
    init_iic_emb_tx();
  }
  I2C->CR2|=I2C_CR2_START; 
  while(!(I2C->SR1 & I2C_SR1_SB));
  I2C->DR = address << 1;
	
  while(!(I2C->SR1 & I2C_SR1_ADDR)){
	if(I2C->SR2 & I2C_SR2_AF) {
  I2C->CR2|=I2C_CR2_STOP; 
	I2C->SR2 &= ~I2C_SR2_AF;
  return;
	}
  }
	I2C->SR3;

  I2C->DR = reg_addr;

while(length--){
  while(!(I2C->SR1 & I2C_SR1_TXE));
  c = *data++;
  I2C->DR = c;
}

while(!((I2C->SR1 & I2C_SR1_TXE) && (I2C->SR1 & I2C_SR1_BTF)));
I2C->CR2|=I2C_CR2_STOP;
while(I2C->CR2 & I2C_CR2_STOP);

}



