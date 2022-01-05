#include "stm8s.h"
#include "rtc.h"
#include "main.h"
#include "encoder.h"
#include "iic_embedded_tx.h"
#include "oled.h"

//globals
encoder_t              encoder;

AlignmentTimeCache     alignmentTimeCache;
TransferBody           transferBody; 
TimeTransferBodyCache  timeTransferBodyCache;
SecondsRtcUtcCache     secondsRtcUtcCache;
DateFromEpochDaysCache dateFromEpochDaysCache;

TransferBody           transferBody;
TimeAlignment          timeAlignment;
eeprom_data_t          eeprom_data @0x4100;         //store setting variables (in EEPROM)()

OledDigitBuffer oledBuffer;

int main() { 
  char i=5;
  init_iic_emb_tx();
  init_encoder(&encoder);
  init_rtc();
	init_ssd1306();
	
  populate_timeAlignment_from_eeprom();
  encoder.but_data_lim = 1;

  while(1) { 
	
	  //TODO brightness
		
		refreshTimeTransferBody();
		i2c_wr_reg(RX_ADDR, 0x00, &transferBody.year, TRANSFERED_SIZE);
		print_time();	
		
    //fall into adjusting parameters
    if (encoder.but_data != 0) {     
      menu_selector();
			oled_Clear_Screen();
    }
  }
}

char menu_selector() {
	LocalTime presetTime;
	LocalDate presetDate;
	TimeAlignment presetCorrection;
	int i;

	//set time	
	presetTime.hr = transferBody.hr;
	presetTime.min = transferBody.min;
	oled_print_XXnumber(0, 96, 1);
	
	encoder.but_data = 0;
	encoder_setter(0, 23, presetTime.hr);
	presetTime.hr = scan_value_at_pos(4);
	oled_print_XXnumber(presetTime.hr, 4, 1);
	
	encoder.but_data = 0;
	encoder_setter(0, 59, presetTime.min);
	presetTime.min = scan_value_at_pos(50);	
	
	//set date
	presetDate.dayOfMonth = transferBody.dayOfMonth;
	presetDate.month = transferBody.month;
  presetDate.year = transferBody.year;	
	oled_print_giga_char('-', 81);
	oled_print_giga_char('-', 35);
	oled_print_XXnumber(presetDate.month, 50, 0); 
	oled_print_XXnumber(presetDate.year, 96, 0);  
	
	encoder.but_data = 0;
	encoder_setter(1, 31, presetDate.dayOfMonth);
	presetDate.dayOfMonth = scan_value_at_pos(4);
	oled_print_XXnumber(presetDate.dayOfMonth, 4, 1);
	
	encoder.but_data = 0;
	encoder_setter(1, 12, presetDate.month);
	presetDate.month = scan_value_at_pos(50);
	oled_print_XXnumber(presetDate.month, 50, 1);
	
	encoder.but_data = 0;
	encoder_setter(0, 99, presetDate.year);
	presetDate.year = scan_value_at_pos(96);
  
	//save date and time if changed
	if(presetDate.dayOfMonth != transferBody.dayOfMonth || presetDate.month != transferBody.month || presetDate.year != transferBody.year || presetTime.hr != transferBody.hr || presetTime.min != transferBody.min) {
		print_save(); 
		rtc_set_time_date(presetTime, presetDate);
    secondsRtcUtcCache.cacheEneble = 0;
		timeAlignment.epochSecFirstPoint = receiveEpochSecondsRtcMoscow();
		saveFirstPointTimeToEeprom();
		
	}
	
	//set correction
	oled_Clear_Screen();
	presetCorrection.timeCorrSec = timeAlignment.timeCorrSec;
	presetCorrection.timeCorrDecaMs = timeAlignment.timeCorrDecaMs;
	presetCorrection.positiveCorr = timeAlignment.positiveCorr;
	oled_print_giga_char('.',48); 
	oled_print_XXnumber(presetCorrection.timeCorrDecaMs, 60, 0); 
		
	encoder.but_data = 0;
	encoder_setter(-99, 99, presetCorrection.positiveCorr ? presetCorrection.timeCorrSec : -presetCorrection.timeCorrSec);
	i = scan_value_at_pos(0);
	presetCorrection.timeCorrSec = (i<0) ? -i : i;
	presetCorrection.positiveCorr = (i<0) ? 0 : 1;
	oled_print_XXnumber(i, 0, 1);
	
	encoder.but_data = 0;
	encoder_setter(0, 99, presetCorrection.timeCorrDecaMs);
	presetCorrection.timeCorrDecaMs = scan_value_at_pos(60);
	
  //save correction if changed
	if(presetCorrection.timeCorrSec != timeAlignment.timeCorrSec || presetCorrection.timeCorrDecaMs != timeAlignment.timeCorrDecaMs || presetCorrection.positiveCorr != timeAlignment.positiveCorr) {
		print_save(); 
		timeAlignment.timeCorrSec = presetCorrection.timeCorrSec;
		timeAlignment.timeCorrDecaMs = presetCorrection.timeCorrDecaMs;
		timeAlignment.positiveCorr = presetCorrection.positiveCorr;
		saveTimeCorrectionToEeprom();		
		alignmentTimeCache.cacheEneble = 0;
	}
	
	//display days from first point	
	oled_Clear_Screen();
	encoder.but_data = 0;
	while(encoder.but_data == 0) {
		i = ((receiveEpochSecondsRtcMoscow() - timeAlignment.epochSecFirstPoint) / 24 / 3600) % 10000;
		oled_print_XXnumber(i % 100, 82, 1);
		i /= 100;
		oled_print_XXnumber(i, 50, 1);
	}
	
	encoder.but_data = 0;
}

int scan_value_at_pos(char pos) {
	char blinking;
	while(encoder.but_data == 0) {
		blinking = (encoder.transient_counter >> 10) & 1;
		oled_print_XXnumber(encoder.enc_data, pos, blinking);
	}
	encoder.but_data = 0;
	return encoder.enc_data;
}

void saveTimeCorrectionToEeprom() { 
  char i;
	sim();
  if (!((FLASH->IAPSR) & (FLASH_IAPSR_DUL))) {  // unlock EEPROM
       FLASH->DUKR = 0xAE;
       FLASH->DUKR = 0x56;
  }
  rim();
  while (!((FLASH->IAPSR) & (FLASH_IAPSR_DUL))) ;
  
  eeprom_data.timeCorrSec = timeAlignment.timeCorrSec;
  eeprom_data.timeCorrDecaMs = timeAlignment.timeCorrDecaMs;
  eeprom_data.positiveCorr = timeAlignment.positiveCorr;
  
  FLASH->IAPSR &= ~(FLASH_IAPSR_DUL);  // lock EEPROM
}  

void saveFirstPointTimeToEeprom() { 
  char i;
	sim();
  if (!((FLASH->IAPSR) & (FLASH_IAPSR_DUL))) {  // unlock EEPROM
       FLASH->DUKR = 0xAE;
       FLASH->DUKR = 0x56;
  }
  rim();
  while (!((FLASH->IAPSR) & (FLASH_IAPSR_DUL))) ;
  
  for(i =0; i<4; i++) {
    eeprom_data.epochSecFirstPoint[i] =  (timeAlignment.epochSecFirstPoint >> (i * 8)) & 0xFF;
  }
    
  FLASH->IAPSR &= ~(FLASH_IAPSR_DUL);  // lock EEPROM
}  

void populate_timeAlignment_from_eeprom() { 
  char i;
  for(i = 0; i<4; i++) {
     timeAlignment.epochSecFirstPoint |=  ((unsigned long) eeprom_data.epochSecFirstPoint[i]) << (i * 8);
  }
  timeAlignment.timeCorrSec = eeprom_data.timeCorrSec;
  timeAlignment.timeCorrDecaMs = eeprom_data.timeCorrDecaMs;
  timeAlignment.positiveCorr = eeprom_data.positiveCorr;
} 
