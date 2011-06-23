module PlatformPinsP {
  provides {
    interface Init;
  }
}

implementation {

  command error_t Init.init() {
    atomic {
    
#if defined(__msp430_have_port1) || defined(__MSP430_HAS_PORT1__) || defined(__MSP430_HAS_PORT1_R__)
      P1DIR = 0xFF;
      P1OUT = 0x0;
#endif 
    
#if defined(__msp430_have_port2) || defined(__MSP430_HAS_PORT2__) || defined(__MSP430_HAS_PORT2_R__)
      P2DIR = 0xFF;
      P2OUT = 0x0;
#endif 
    
#if defined(__msp430_have_port3) || defined(__MSP430_HAS_PORT3__) || defined(__MSP430_HAS_PORT3_R__)
      P3DIR = 0xFF;
      P3OUT = 0x0;
#endif 

#if defined(__msp430_have_port4) || defined(__MSP430_HAS_PORT4__) || defined(__MSP430_HAS_PORT4_R__)
      P4DIR = 0xFF;
      P4OUT = 0x0;
#endif 
    
#if defined(__msp430_have_port5) || defined(__MSP430_HAS_PORT5__) || defined(__MSP430_HAS_PORT5_R__)
      P5DIR = 0xFF;
      P5OUT = 0x0;
#endif 

#if defined(__msp430_have_port6) || defined(__MSP430_HAS_PORT6__) || defined(__MSP430_HAS_PORT6_R__)
      P6DIR = 0xFF;
      P6OUT = 0x0;
#endif 
    
#if defined(__msp430_have_port7) || defined(__MSP430_HAS_PORT7__) || defined(__MSP430_HAS_PORT7_R__)
      P7DIR = 0xFF;
      P7OUT = 0x0;
#endif 
    
#if defined(__msp430_have_port8) || defined(__MSP430_HAS_PORT8__) || defined(__MSP430_HAS_PORT8_R__)
      P8DIR = 0xFF;
      P8OUT = 0x0;
#endif 
    
#if defined(__msp430_have_port9) || defined(__MSP430_HAS_PORT9__) || defined(__MSP430_HAS_PORT9_R__)
      P9DIR = 0xFF;
      P9OUT = 0x0;
#endif 
    
#if defined(__msp430_have_port10) || defined(__MSP430_HAS_PORT10__) || defined(__MSP430_HAS_PORT10_R__)
      P10DIR = 0xFF;
      P10OUT = 0x0;
#endif 
    
#if defined(__msp430_have_port11) || defined(__MSP430_HAS_PORT11__) || defined(__MSP430_HAS_PORT11_R__)
      P11DIR = 0xFF;
      P11OUT = 0x0;
#endif 
    
#if defined(__msp430_have_portJ) || defined(__MSP430_HAS_PORTJ__) || defined(__MSP430_HAS_PORTJ_R__)
      PJDIR = 0xFF;
      PJOUT = 0x0;
#endif 

#if 0 /* Disabled: these specific setting sare defaults, but others might not be */
      PMAPPWD = PMAPPW;                         // Get write-access to port mapping regs  
      P1MAP5 = PM_UCA0RXD;                      // Map UCA0RXD output to P1.5
      P1MAP6 = PM_UCA0TXD;                      // Map UCA0TXD output to P1.6

      P1MAP2 = PM_UCB0SCL;                      // Map I2C SCL to P1.2
      P1MAP3 = PM_UCB0SDA;                      // Map I2C Data to P1.3

 //     P1MAP2 = PM.UCB0SIMO;			// Map SPI Data Out P1.2
 //     P1MAP3 = PM.UCB0SOMI;			// Map SPI Data In P1.3
 //     P1MAP4 = PM.UCB0CLK;			// Map SPI CLK to P1.4
      PMAPPWD = 0;                              // Lock port mapping registers 
#endif //

    }
    return SUCCESS;

  }
  
}
