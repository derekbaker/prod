#include "Timer.h"
#include "printfZ1.h"
#define FADSAMPLES 2000
#define PRINTBUF 20

module FastADCC
{
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as TimerBlink;
  uses interface Timer<TMilli> as TimerSample;
  
  uses interface Msp430Adc12Overflow as overflow;
  uses interface Msp430Adc12SingleChannel as adc;
  uses interface Resource;
  
  uses interface BlockWrite;
  uses interface BlockRead;  
}
implementation
{
  
  uint16_t adb[FADSAMPLES];
  uint16_t pb[PRINTBUF];
  uint16_t pos;
  
  msp430adc12_channel_config_t adcconfig = {
    inch: TEMPERATURE_DIODE_CHANNEL,
    sref: REFERENCE_AVcc_AVss,
    ref2_5v: REFVOLT_LEVEL_1_5,
    adc12ssel: SHT_SOURCE_ACLK,
    adc12div: SHT_CLOCK_DIV_1,
    sht: SAMPLE_HOLD_4_CYCLES,
    sampcon_ssel: SAMPCON_SOURCE_SMCLK,
    sampcon_id: SAMPCON_CLOCK_DIV_1
  };

  void showerror(){
  	call Leds.led0On();
  }

  void configureSingle(){
	error_t e;
	printfz1("configuring single\n");
  	e = call adc.configureSingle(&adcconfig);
    if(e != SUCCESS)
    	showerror();
    printfz1("error %d\n", e);
  }
  
  void configureMultiple(){
  	error_t e;
  	printfz1("configuring multiple\n");
  	e = call adc.configureMultiple(&adcconfig, adb, FADSAMPLES, 3); 
    if(e != SUCCESS)
    	showerror();
    printfz1("error %d\n", e);
  
  }
  
  void printadb(){
  	uint16_t i;
  	printfz1("printing buffer\n");
  	for(i = 0; i < FADSAMPLES; i++){
  		printfz1("adb[%d] = %d\n", i, adb[i]);
  	}
  }
  
  void writeadb(){
  	printfz1("writing adb\n");
  	call BlockWrite.write(0, adb, FADSAMPLES);
  }
  
  void readadb(){
  
  }
  
  event void Boot.booted()
  {
    printfz1_init();
    printfz1("booting\n");
    
    call Resource.request();
    
  }

  event void TimerBlink.fired()
  {
    call Leds.led0Toggle();
    call Leds.led1Toggle();
    call Leds.led2Toggle();
  }
  
  event void TimerSample.fired(){
  	error_t e;
  	printfz1("starting conversion\n");
  	e = call adc.getData();
  	printfz1("error %d\n", e);
  }
  
  async event void overflow.conversionTimeOverflow(){
 	
  }

  async event void overflow.memOverflow(){
	
  }
  
  async event uint16_t *adc.multipleDataReady(uint16_t *buffer, uint16_t numSamples){
  	printfz1("samples ready\n");
  	writeadb();
  	printadb();
  	return buffer;
  }

  async event error_t adc.singleDataReady(uint16_t data){
     //printfz1("sample: %d\n", data);
     return SUCCESS;
  }   
  
  event void Resource.granted(){
  	printfz1("Resource granted\n");
    configureMultiple();
    call TimerSample.startOneShot(1000);
  } 
  
  event void BlockRead.readDone(storage_addr_t x, void* buf, storage_len_t y, error_t result) {

  }
  
  event void BlockWrite.eraseDone(error_t result) {
  
  }
  
  event void BlockWrite.writeDone(storage_addr_t x, void* buf, storage_len_t y, error_t result) {
  	printfz1("write done -> %d\n", result);
  	if (result == SUCCESS){
  	  printfz1("syncing\n");
      call BlockWrite.sync();
    }
  }
  
  event void BlockWrite.syncDone(error_t result) {
  	printfz1("sync done -> %d\n", result);
  }
  
  event void BlockRead.computeCrcDone(storage_addr_t x, storage_len_t y, uint16_t z, error_t result) {
  
  }
}