#include <stdio.h>
#include <I2C.h>

module I2CP{
	uses interface Boot;
	uses interface UartStream;
	uses interface StdControl;
	uses interface I2CPacket<TI2CBasicAddr>;

}

implementation{
uint8_t EE_senddata[15],EE_recdata[15];
char CmdBuffer[50];
int Ptr=0;
int HaveCmd=0;

  event void Boot.booted ()
  {
int Cmd=0;


    	call StdControl.start();
 
 		EE_senddata[0]=0x00;			//high byte address
		EE_senddata[1]=0x40;			//low byte address
		EE_senddata[2]=0x41;			//A
		EE_senddata[3]=0x42;			//B
		EE_senddata[4]=0x43;			//C	
		EE_senddata[5]=0x44;			//D
		EE_senddata[6]=0x45;			//E
		EE_senddata[7]=0x46;			//F
		EE_senddata[8]=0x47;			//G
		
												
        while(1) {
                atomic {
                        Cmd=HaveCmd;
                }
                if(Cmd==1) {
                        if(strcmp(CmdBuffer,"hi")==0) {
                                call UartStream.send((uint8_t *)"\n\rhello back\n\r>",15);				//CLI Test
                        }
                        if(strcmp(CmdBuffer,"testsend")==0) {
                       		call I2CPacket.write(I2C_START | I2C_STOP, 0x0050, 9, EE_senddata);			//Write ABCDEFG to eeprom addr 0x0050
                        }
                        if(strcmp(CmdBuffer,"testset")==0) {
                       		call I2CPacket.write(I2C_START | I2C_STOP, 0x0050, 2, EE_senddata);			//set the eeprom internal addr to 0x0050
                        }
                        if(strcmp(CmdBuffer,"testrec")==0) {
	                     	call I2CPacket.write(I2C_START, 0x0050, 2, EE_senddata);					//set the eeprom internal addr to 0x0050
                        	call I2CPacket.read(I2C_START | I2C_STOP, 0x0050,7, EE_recdata);			//read 7 bytes from current eeprom addr
                        }        
                        atomic {
                                HaveCmd=0;
                                Ptr=0;
                        }
                }
        }
  }

  async event void UartStream.receiveDone (uint8_t* buf, uint16_t len, error_t error) { }
  async event void UartStream.sendDone (uint8_t* buf, uint16_t len, error_t error) { }

  async event void UartStream.receivedByte (uint8_t byte)
  {
	switch (byte) {
		case 8:												/*do we have a backspace*/
		case 127:											/*do we have a delete*/
			if(Ptr != 0) {									/*if its not the first char*/
				Ptr--;										/*move the command pointer back one*/
				call UartStream.send((uint8_t *)"\b \b",3);	/*Erase the char*/
			}
			break;
		case 10:											/*do we have a cr*/
		case 13:											/*do we have a lf*/
			if(Ptr==0) {
				call UartStream.send((uint8_t *)"\n\r>",3);
			} else {
				CmdBuffer[Ptr++] = '\0';					/*command entered so terminate the command string*/
				HaveCmd=1;									/*Let the main loop know we have a command to process*/
			}
			break;
		default:											/*everything else*/
			if(Ptr == 49) {									/*is our command string getting to big for buffer 49?*/
				call UartStream.send((uint8_t*)7,1);		/*yes send a bell*/
				Ptr--;										/*move the command pointer back one*/
				call UartStream.send((uint8_t*)"\b \b",3);	/*Erase the char*/
			} else {
				CmdBuffer[Ptr++] = byte;					/*add the char to the command buffer and add one to the command pointer*/
				call UartStream.send(&byte,1);				/*echo it back*/
			}
		}
  	}  
  
  	async event void I2CPacket.writeDone(error_t error, uint16_t addr, uint8_t length, uint8_t *data){
  		if(error==FAIL) {
  			call UartStream.send((uint8_t *)"\n\rFAILED ",9);	
  		} 
  		if(error==SUCCESS) {
  			call UartStream.send((uint8_t *)"\n\rSUCCESS ",10);
  		}
  		call UartStream.send((uint8_t *)"Write I2C\n\r>",13);
  	}

	async event void I2CPacket.readDone(error_t error, uint16_t addr, uint8_t length, uint8_t *data){
		if(error==FAIL) {
  			call UartStream.send((uint8_t *)"\n\rFAILED ",9);	
  		}
  		if(error==SUCCESS) {
  			call UartStream.send((uint8_t *)"\n\rSUCCESS ",10);
  			
  			if(addr==0x0050) {								/*Data from EEProm*/
  				call UartStream.send(data, 7);
  			}
            call UartStream.send((uint8_t*)"\n\r>",3);
 		}
  		call UartStream.send((uint8_t *)"Read I2C\n\r>",12);
  		
	}
}
