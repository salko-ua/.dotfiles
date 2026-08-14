{pkgs, ...}: let
  bitwarden = pkgs.unstable.bitwarden-desktop;
in {
  home.packages = [bitwarden];

  # Started as a systemd user service rather than an XDG autostart entry, purely
  # so it can be ordered after the desktop portal.
  #
  # Bitwarden is Electron and reads the dark/light preference from
  # org.freedesktop.portal.Settings exactly once at startup. As a plain autostart
  # entry it beat the portal by a second:
  #
  #   app-bitwarden@autostart.service  12:49:39
  #   xdg-desktop-portal.service       12:49:40
  #
  # ...got no answer, and came up light for the whole session. Whether it won or
  # lost that race varied per boot, which is why it looked fixed and then wasn't.
  # Same failure and same fix as home-manager/programs/easyeffects.nix.
  #
  # Wants= matters as much as After=: the portal is D-Bus activated, so ordering
  # against a unit nothing pulls into the transaction achieves nothing.
  systemd.user.services.bitwarden = {
    Unit = {
      Description = "Bitwarden";
      After = ["graphical-session.target" "xdg-desktop-portal.service"];
      Wants = ["xdg-desktop-portal.service"];
      PartOf = ["graphical-session.target"];
    };

    Install.WantedBy = ["graphical-session.target"];

    Service = {
      ExecStart = "${bitwarden}/bin/bitwarden";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  # Bitwarden rewrites this file itself whenever its own "start automatically on
  # login" toggle is used, which would then launch a second copy alongside the
  # service above. Declaring it with Hidden=true means the XDG autostart spec
  # tells the session to ignore it, and force lets activation overwrite whatever
  # Bitwarden last wrote.
  xdg.configFile."autostart/bitwarden.desktop" = {
    force = true;
    text = ''
      [Desktop Entry]
      Version=1.0
      Type=Application
      Name=Bitwarden
      Comment=Superseded by the bitwarden.service user unit
      Exec=${bitwarden}/bin/bitwarden
      Hidden=true
    '';
  };
}
