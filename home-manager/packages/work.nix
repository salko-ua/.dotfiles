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
    actual-client
  ];
}
