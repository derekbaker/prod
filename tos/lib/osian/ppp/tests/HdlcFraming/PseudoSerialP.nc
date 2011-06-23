/* Copyright (c) 2011 People Power Co.
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
 * - Neither the name of the People Power Corporation nor the names of
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
 *
 */

module PseudoSerialP {
  provides {
    interface StdControl;
    interface HdlcUart;
    interface PseudoSerial;
  }
} implementation {

#ifndef PSEUDOSERIAL_MAX_TX_BUFFER
#define PSEUDOSERIAL_MAX_TX_BUFFER 512
#endif /* PSEUDOSERIAL_MAX_TX_BUFFER */

  bool inhibit_rx;
  uint8_t* rx_buffer;
  uint16_t rx_buffer_idx;
  uint16_t rx_buffer_length;

  command error_t StdControl.start ()
  {
    inhibit_rx = FALSE;
    return SUCCESS;
  }
  command error_t StdControl.stop ()
  {
    inhibit_rx = TRUE;
    return SUCCESS;
  }

  command error_t HdlcUart.send (uint8_t* buf, uint16_t len) { return FAIL; }
  // async event void HdlcUart.sendDone (error_t err) { }

  // async event void UartStream.receiveDone (uint8_t* buf, uint16_t len, error_t err) { }
  
  command error_t PseudoSerial.feedUartByte (uint8_t byte)
  {
    signal HdlcUart.receivedByte(byte);
    return SUCCESS;
  }


  command error_t PseudoSerial.feedUartStream (const uint8_t* data,
                                               unsigned int len)
  {
    const uint8_t* dp = data; 
    const uint8_t* dpe = dp + len;
    while (dp < dpe) {
      call PseudoSerial.feedUartByte(*dp++);
    }
    return SUCCESS;
  }

  command unsigned int PseudoSerial.consumeUartStream (uint8_t* data,
                                                       unsigned int max_len)
  {
    return FAIL;
  }
  
}
