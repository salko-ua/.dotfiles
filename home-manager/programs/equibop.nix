{pkgs, ...}: let
  # Equibop's native tray backend (libvesktop-x64.node, dlopen'd out of
  # app.asar) needs libstdc++.so.6. Electron's RUNPATH does not cover the
  # dependencies of dlopen'd objects, so the load fails and Equibop falls back
  # to the Electron Tray -- whose Linux branch only registers a `right-click`
  # handler that Electron never emits, leaving the tray icon with no menu.
  equibop = pkgs.symlinkJoin {
    name = "equibop-${pkgs.equibop.version}";
    paths = [pkgs.equibop];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/equibop \
        --prefix LD_LIBRARY_PATH : ${pkgs.stdenv.cc.cc.lib}/lib
    '';
  };
in {
  home.packages = [equibop];

  services.arrpc.enable = true;

  # Equibop's own "Start With System" toggle writes an Exec= that invokes
  # electron-unwrapped directly (Electron's process.execPath), bypassing the Nix
  # wrapper that is the only thing exporting CHROME_DEVEL_SANDBOX -- Chromium's
  # sandbox init then hits IMMEDIATE_CRASH() and dies with SIGILL on every boot.
  # Always Exec the wrapper; it derives the speech and Wayland flags itself from
  # NIXOS_SPEECH / NIXOS_OZONE_WL + WAYLAND_DISPLAY.
  # force, because the toggle described above rewrites this file itself; without
  # it, flipping that setting once makes the next activation abort with
  # "would be clobbered".
  xdg.configFile."autostart/equibop.desktop" = {
    force = true;
    text = ''
      [Desktop Entry]
      Type=Application
      Name=Equibop
      Comment=Equibop autostart script
      Exec=${equibop}/bin/equibop
      StartupNotify=false
      Terminal=false
      Icon=equibop
    '';
  };
}
