/*
 * Copyright (c) 2010-2011 Eric B. Decker
 * Copyright (c) 2009 DEXMA SENSORS SL
 * Copyright (c) 2005-2006 Arch Rock Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 *
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 *
 * - Neither the name of the copyright holders nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * Provides an interface for usci A1 on the MSP430.
 *
 * @author Jonathan Hui <jhui@archedrock.com>
 * @author Xavier Orduna <xorduna@dexmatech.com>
 * @author Eric B. Decker <cire831@gmail.com>
 */

generic configuration Msp430UsciA1C() {
  provides {
    interface Resource;			/* parameterized */
    interface ResourceRequested;	/* parameterized */
    interface ArbiterInfo;
    interface HplMsp430UsciA;
    interface HplMsp430UsciInterrupts;	/* parameterized */
  }
  uses interface ResourceConfigure;	/* parameterized */
}

implementation {
  enum {
    CLIENT_ID = unique( MSP430_HPLUSCIA1_RESOURCE ),
  };

  components Msp430UsciShareA1P as UsciShareP;

  Resource = UsciShareP.Resource[ CLIENT_ID ];
  ResourceRequested = UsciShareP.ResourceRequested[ CLIENT_ID ];
  ResourceConfigure = UsciShareP.ResourceConfigure[ CLIENT_ID ];
  ArbiterInfo = UsciShareP.ArbiterInfo;
  HplMsp430UsciInterrupts = UsciShareP.Interrupts[ CLIENT_ID ];

  components HplMsp430UsciA1C as HplUsciC;
  HplMsp430UsciA = HplUsciC;
}