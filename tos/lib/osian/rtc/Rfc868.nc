/* Copyright (c) 2010 People Power Co.
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

#include "RealTimeClock.h"

/** Support conversions between RFC868 seconds-since-epoch and
 * standard struct tm breakdowns.
 *
 * @author Peter A. Bigot <pab@peoplepowerco.com>
 */
interface Rfc868 {
  /** Calculate an RFC868 time from a time structure.
   *
   * RFC868 expresses times as the number of atomic seconds since its
   * epoch, 1900-01-01T00:00:00Z.
   *
   * @param time The time for which an epoch-relative offset is
   * required.  tm_sec, tm_min, tm_hour, tm_mon, tm_mday, and tm_year
   * contribute; all other fields are ignored.
   *
   * @return Atomic seconds since epoch.  Zero if the timepor
   */
  command uint32_t fromTime (const struct tm* time);

  /** Convert an RFC868 time to a time structure.
   *
   * @param time_rfc868 Atomic seconds since the RFC868 epoch.
   *
   * @param time Where to store the resulting time.  Fields tm_sec,
   * tm_min, tm_hour, tm_mday, tm_mon, tm_year, tm_wday, and tm_yday
   * are set.
   *
   * @return SUCCESS, or EINVAL if time is a null pointer. */
  command error_t toTime (uint32_t time_rfc868,
                          struct tm* time);

  /** Return the offset, in seconds, of the POSIX epoch
   * (1970-01-01T00:00:00Z) from the RFC868 epoch
   * (1900-01-01T00:00:00Z).
   * 
   * @return 2208988800 */
  command uint32_t posixEpochOffset ();
}