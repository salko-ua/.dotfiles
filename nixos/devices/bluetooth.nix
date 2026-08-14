{
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # The Realtek RTL8922AU bluetooth radio wedges its firmware when USB
  # autosuspend puts it to sleep mid-stream:
  #
  #   Bluetooth: hci0: command tx timeout
  #   Bluetooth: hci0: Resetting usb device.
  #   usb 1-6: reset full-speed USB device number 4 using xhci_hcd
  #
  # The kernel then re-enumerates it as hci1, which tears down the A2DP stream.
  # That is both the "sound cuts out and comes back" symptom and the trigger for
  # CS2 segfaulting inside libspa-audioconvert while the stream renegotiates
  # underneath it. Default was control=auto with a 2s idle delay.
  #
  # Matched on the device's own USB id (13d3:3617) rather than disabling
  # autosuspend globally via usbcore.autosuspend, which would also keep every
  # other USB device permanently awake.
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="13d3", ATTR{idProduct}=="3617", TEST=="power/control", ATTR{power/control}="on"
  '';
}
