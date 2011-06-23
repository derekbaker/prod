configuration I2CAppC {
} implementation {
  components MainC;
  components I2CP;

  I2CP.Boot -> MainC;

  components PlatformSerialC;
  components PlatformI2CC;
 
  I2CP.I2CPacket -> PlatformI2CC;
  I2CP.UartStream -> PlatformSerialC;
  I2CP.StdControl -> PlatformI2CC;
  I2CP.StdControl -> PlatformSerialC;
  
  components SerialPrintfC;

}
