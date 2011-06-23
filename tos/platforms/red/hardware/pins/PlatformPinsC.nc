configuration PlatformPinsC {
  provides {
    interface Init;
  }
}

implementation {
  components PlatformPinsP;
  Init = PlatformPinsP;
}
