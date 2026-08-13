{pkgs, ...}: let
  bitwarden = pkgs.unstable.bitwarden-desktop;
in {
  home.packages = [bitwarden];

  # Bitwarden's own "start automatically on login" toggle writes this file into
  # ~/.config/autostart, which on salo-pc is the wiped root -- so it stuck on the
  # laptop and disappeared every boot on the PC. It also bakes in whatever store
  # path was current when you ticked the box, so the imperative version goes
  # stale on the next bitwarden update; interpolating the package fixes that.
  # force: bitwarden writes this file itself, so an unmanaged copy is always
  # possible (and exists on the laptop) -- without it activation aborts with
  # "would be clobbered", since standalone home-manager has no
  # backupFileExtension option to fall back on.
  xdg.configFile."autostart/bitwarden.desktop" = {
    force = true;
    text = ''
      [Desktop Entry]
      Version=1.0
      Type=Application
      Name=Bitwarden
      Comment=Bitwarden startup script
      Exec=${bitwarden}/bin/bitwarden
      StartupNotify=false
      Terminal=false
    '';
  };
}
