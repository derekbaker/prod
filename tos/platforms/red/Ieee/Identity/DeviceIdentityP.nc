/*
 * Copyright (c) 2009-2010 People Power Company
 * All rights reserved.
 *
 * This open source code was developed with funding from People Power Company
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the People Power Company nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * PEOPLE POWER CO. OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

#include "odi.h"

/**
 * @author David Moss
 * @author Peter Bigot
 */
module DeviceIdentityP {
  provides {
    interface Init;
    interface DeviceIdentity;
  }
  uses interface I2CPacket<TI2CBasicAddr>;
  uses interface StdControl;
} implementation {

/* Set default metadata values */
#ifndef OSIAN_DEVICE_OUI
#define OSIAN_DEVICE_OUI 0xB0C8AD
#endif /* OSIAN_DEVICE_OUI */
#ifndef OSIAN_DEVICE_SENSOR
#define OSIAN_DEVICE_SENSOR 0
#endif /* OSIAN_DEVICE_SENSOR */
#ifndef OSIAN_DEVICE_ACTUATOR
#define OSIAN_DEVICE_ACTUATOR 0
#endif /* OSIAN_DEVICE_ACTUATOR */
#ifndef OSIAN_DEVICE_CLASS
#define OSIAN_DEVICE_CLASS ODI_CLS_Unregistered
#endif /* OSIAN_DEVICE_CLASS */
#ifndef OSIAN_DEVICE_TYPE
#define OSIAN_DEVICE_TYPE 1
#endif /* OSIAN_DEVICE_TYPE */
#ifndef OSIAN_DEVICE_ID
#define OSIAN_DEVICE_ID 0x414243
#endif /*OSIAN_DEVICE_ID*/

  /** OSIAN Device Identifier, basically an EUI-64 with extra info.
   *
   * @note Don't bother trying to initialize this at compile-time.
   * nx_structs with bit fields don't translate into something that
   * can be statically initialized. */
  odi_t odi;

  command error_t Init.init ()
  {
    static bool done;
    error_t rc = SUCCESS;
    if (done) {
      return SUCCESS;
    }
    done = TRUE;
    //the following forms the address 'B0C8:AD00:0141:4243' -> ultimatly turns into local-link address 'FE80::B2C8:AD00:0141:4243'
    //Byte 7 changes from B0 to B2 because lib/net/oip/DeviceModifiedUui64P changes it to mark as a IPv6 interface identifier.
    odi.oui = OSIAN_DEVICE_OUI;
    odi.reserved = 0;
    odi.sensor = OSIAN_DEVICE_SENSOR;
    odi.actuator = OSIAN_DEVICE_ACTUATOR;
    odi.deviceClass = OSIAN_DEVICE_CLASS;
    odi.deviceType = OSIAN_DEVICE_TYPE;
    odi.id = OSIAN_DEVICE_ID;
    {
      //The following checks the EEPROM and used the Global address's last 3 bytes to form the odi.id
      //The last two bytes are used to form the IEEE154 Pan addr, these two bytes must be the same in the local-link and global address
      //else the packet is dropped by the IEEE154 layer.
      uint32_t id = 0;
      uint8_t EE_senddata[5],EE_recdata[16];

      call StdControl.start();

      EE_senddata[0]=0x31;	                                                //high byte address of the EEPROM init flag
      EE_senddata[1]=0x01;                                                      //low byte address
      rc = call I2CPacket.write(I2C_START, 0x0050, 2, EE_senddata);		//set the eeprom internal addr to 0x0131
      rc = call I2CPacket.read(I2C_START | I2C_STOP, 0x0050,1, EE_recdata);     //load the EEPROM init flag
      if(rc==FAIL || EE_recdata[0]!=0x08) return rc;                            //If the load failed or the EEPROM is not init return and except the defaults

      EE_senddata[0]=0x00;	                                                //high byte address of the EEPROM GlobalAddress
      EE_senddata[1]=0x00;                                                      //low byte of address
      rc = call I2CPacket.write(I2C_START, 0x0050, 2, EE_senddata);		//set the eeprom internal addr to 0x0000
      rc = call I2CPacket.read(I2C_START | I2C_STOP, 0x0050,16, EE_recdata); 	//read the GlobalAddress
      if (SUCCESS == rc) {                                                      //Use the GlobalAddress's last 3 bytes to for the unique id
        id = (id << 8) | EE_recdata[13];
        id = (id << 8) | EE_recdata[14];
        id = (id << 8) | EE_recdata[15];
      }
      odi.id = id;
    }
    return rc;
  }

  command const odi_t* DeviceIdentity.get ()
  {
    call Init.init();
    return &odi;
  }

  command const ieee_eui64_t* DeviceIdentity.getEui64 () { return (const ieee_eui64_t*)call DeviceIdentity.get(); }

  command const char * DeviceIdentity.getDescription () { return 0; }

  async event void I2CPacket.writeDone(error_t error, uint16_t addr, uint8_t length, uint8_t *data) { }

  async event void I2CPacket.readDone(error_t error, uint16_t addr, uint8_t length, uint8_t *data) { }

}
