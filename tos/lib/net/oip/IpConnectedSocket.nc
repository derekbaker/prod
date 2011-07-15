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

#include <sys/socket.h>

/** Interface providing POSIX-style send/recv operations.
 *
 * For times when you only talk with one remote node.
 *
 * @see IpSocket for basic POSIX socket operations
 *
 * @warning The receive event for this interface will not be signalled
 * if the IpDatagramSocket or IpSocketMsg interfaces for the socket
 * are wired in.
 *
 * @author Peter A. Bigot <pab@peoplepowerco.com>
 */
interface IpConnectedSocket {
  /** Return the socket id.
   *
   * Use to identify the IpSocket for which this provides an
   * interface. */
  command int descriptor ();

  /** Notification that a message has been received on the socket.
   *
   * @param buffer a message received from the peer
   * @param length the number of octets in the data
   * @param flags Not used
   *
   * @note Unlike the POSIX API, the OSIAN interface models packet
   * reception as an event rather than a command.  As such, the buffer
   * parameter is immutable and holds the message content.
   *
   * @warning recv will only be signaled if neither IpSocketMsg nor
   * IpDatagramSocket are wired for this socket.  If either is, you
   * must use their receive functions.
   */
  event void recv (const void* buffer,
                   size_t length,
                   int flags);

  /** Transmit a message to the connected peer.
   *
   * @param buffer the message to be sent
   * @param length the number of octets in the message
   * @param flags Not used
   *
   * @return FAIL if the socket is not connected.
   */
  command error_t send (const void* buffer,
                        size_t length,
                        int flags);
}
