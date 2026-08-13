{pkgs, ...}: let
  tls12cap = pkgs.runCommandCC "tls12cap" {} ''
    mkdir -p $out/lib
    $CC -shared -fPIC -O2 -o $out/lib/tls12cap.so ${./tls12cap.c}
  '';

  remmina-tls12 = pkgs.symlinkJoin {
    name = "remmina-tls12-${pkgs.remmina.version}";
    paths = [pkgs.remmina];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      for bin in $out/bin/*; do
        wrapProgram "$bin" --set LD_PRELOAD ${tls12cap}/lib/tls12cap.so
      done
      for desktop in $out/share/applications/*.desktop; do
        target=$(readlink -f "$desktop")
        rm "$desktop"
        substitute "$target" "$desktop" --replace-quiet "${pkgs.remmina}/bin" "$out/bin"
      done
    '';
  };
in {
  home.packages = with pkgs; [
    openvpn
    remmina-tls12
    unixodbcDrivers.msodbcsql17
  ];

  # Remmina's own "start in tray on login" toggle writes this file itself, into
  # ~/.config/autostart -- which on salo-pc is the wiped root, so it survived on
  # the laptop and vanished every boot on the PC. Declaring it is the fix;
  # persisting ~/.config/autostart would only paper over it.
  #
  # Exec points at the wrapper rather than a bare `remmina` so the TLS 1.2 shim
  # above is guaranteed to be LD_PRELOADed regardless of PATH (the PC resolves
  # packages through /etc/profiles/per-user, the laptop through ~/.nix-profile).
  # -i starts it iconified in the tray instead of opening the main window.
  xdg.configFile."autostart/remmina-applet.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Remmina Applet
    Comment=Connect to remote desktops through the applet menu
    Exec=${remmina-tls12}/bin/remmina -i
    Icon=org.remmina.Remmina
    Terminal=false
    Hidden=false
  '';
}
