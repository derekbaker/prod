// $Id: Ds2401.h,v 1.1 2008/10/31 17:02:55 sallai Exp $
/*
 * Copyright (c) 2007, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE VANDERBILT UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE VANDERBILT UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 */
 
/**
 * @author Janos Sallai
 * @author David Moss
 */

#ifndef ONEWIRE_H
#define ONEWIRE_H

enum {
  ONEWIRE_SERIAL_LENGTH = 6,
  ONEWIRE_DATA_LENGTH = 8
};

typedef union onewire_t {
  uint8_t data[ONEWIRE_DATA_LENGTH];
  
  struct {
     uint8_t familyCode;
     uint8_t serial[ONEWIRE_SERIAL_LENGTH];
     uint8_t crc;
  };
  
} onewire_t;

#endif // ONEWIRE_H
