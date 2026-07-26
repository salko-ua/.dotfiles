{pkgs, ...}: {
  home.packages = [pkgs.equibop];

  services.arrpc.enable = true;

  # Equibop's own "Start With System" toggle writes an Exec= that invokes
  # electron-unwrapped directly (Electron's process.execPath), bypassing the Nix
  # wrapper that is the only thing exporting CHROME_DEVEL_SANDBOX -- Chromium's
  # sandbox init then hits IMMEDIATE_CRASH() and dies with SIGILL on every boot.
  # Always Exec the wrapper; it derives the speech and Wayland flags itself from
  # NIXOS_SPEECH / NIXOS_OZONE_WL + WAYLAND_DISPLAY.
  xdg.configFile."autostart/equibop.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Equibop
    Comment=Equibop autostart script
    Exec=${pkgs.equibop}/bin/equibop
    StartupNotify=false
    Terminal=false
    Icon=equibop
  '';
}
