#ifndef _H_hardware_h
#define _H_hardware_h

#include "msp430hardware.h"

// enum so components can override power saving,
// as per TEP 112.
enum {
  TOS_SLEEP_NONE = MSP430_POWER_ACTIVE,
};

/* Use the PlatformAdcC component, and enable 6 pins */
#define ADC12_USE_PLATFORM_ADC 1
#define ADC12_PIN_AUTO_CONFIGURE 1
#define ADC12_PINS_AVAILABLE 6

/*
 * The cc430f5137 includes the RF1A.   When the radio is being used
 * the PMM VCORE setting must be at or abore 2.
 */

#define RADIO_VCORE_LEVEL 2


#endif // _H_hardware_h
