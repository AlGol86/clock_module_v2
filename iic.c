//this example is intended for 8 MHz clock frequency
#include "stm8s.h"
#include "iic.h"

char get_addresses_iic( char n )
{
  char count_addr=0;
	char i;
  for (i=1;i<128;i++)
  {
   if(!start_iic(i,WRITE))
   {stop_iic();
   count_addr++;}
  }
  return count_addr;
}

void sys_del_us(char del_us)	
{
char i;
for(i=0;i<del_us;i++)
{nop();}
}

char start_iic (char adr_iic, char read_write_bit)
{
	//configuration pins (sda,clk) 
	GPIOB->CR2&=~BIT_clk; //PA_clk_pin  - low speed (interrupt disabled)
	GPIOB->CR1&=~BIT_clk; //PA_clk_pin  - open drain /float in inp. direct
	GPIOB->ODR|=BIT_clk; //PA_clk_pin  - 1 (CLOCK)
	GPIOB->DDR|=BIT_clk; 
	GPIOB->CR2&=~BIT_sda; //PA_sda_pin  - low speed (interrupt disabled)
	GPIOB->CR1&=~BIT_sda; //PA_sda_pin - open drain /float in inp. direct
	GPIOB->ODR|=BIT_sda; //PA_sda_pin  - 1 (SDA)
	GPIOB->DDR|=BIT_sda; 
	
	//(SDA) "START!!!!" 
	GPIOB->ODR&=~BIT_sda; 											//set sda=0
	nop();//>0.1us
	return send_byte ((adr_iic<<1)+read_write_bit);
}	
	
char send_byte (char data_byte)
{
	//send start byte
	char i;
	for(i=8;i>0;i--)
	 {                                   
	 GPIOB->ODR&=~BIT_clk;//clock=0
         GPIOB->ODR&=~BIT_sda;//set data=0
	 sys_del_us(2);//>2us
	 GPIOB->ODR|=((data_byte>>(i-1))&1)<<PIN_sda;//set data
	 sys_del_us(1); //>0.1us
	 GPIOB->ODR|=BIT_clk;//clock=1
	 sys_del_us(1);//>1us
	 }
	// assert acknowledge
	GPIOB->ODR&=~BIT_clk;											//clock=0
	sys_del_us(2);//>2us
	GPIOB->ODR|=BIT_sda;                     //set data=1
	sys_del_us(1);//>0.1us
	GPIOB->ODR|=BIT_clk;											//clock=1
	 sys_del_us(1);//>1us
	if ((GPIOB->IDR&BIT_sda)==0) 
	return ACK; 
	else 
	return NOT_ACK;
}

unsigned char receive_byte (char acknowledge)
{
	//send start byte
	char i;
	char receive_b=0;
	for(i=8;i>0;i--)
	 {
	 GPIOB->ODR&=~BIT_clk;											//clock=0
	 sys_del_us(4);//>5us
	 GPIOB->ODR|=BIT_clk;											//clock=1
	 sys_del_us(4);//>5us
	 GPIOB->DDR&=~BIT_sda;
	 receive_b|=(((GPIOB->IDR)&BIT_sda)>>PIN_sda)<<(i-1);
	 GPIOB->DDR|=BIT_sda;
	 }
	// send acknowledge
	GPIOB->ODR&=~BIT_clk;										//clock=0
	if(acknowledge) GPIOB->ODR&=~BIT_sda;     //set data=0	
	sys_del_us(2);//>2us
	GPIOB->ODR|=BIT_clk;											//clock=1
	sys_del_us(2);//>1us
	GPIOB->ODR&=~BIT_clk;											//clock=0
	GPIOB->ODR|=BIT_sda; 
	
	return receive_b;
}	
	
void stop_iic (void)
{	 
  GPIOB->ODR&=~BIT_clk;											//clock=0
	sys_del_us(2);//>2us
	GPIOB->ODR&=~BIT_sda; 											//set sda=0
	nop(); //>0.1us
	GPIOB->ODR|=BIT_clk;											//clock=1
	nop();//>0.1us
	GPIOB->ODR|=BIT_sda; 											//set sda=1
}