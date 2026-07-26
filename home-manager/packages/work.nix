{pkgs, ...}: {
  home.packages = with pkgs; [
    openvpn
    remmina
    unixodbcDrivers.msodbcsql17
    actual-client
  ];
}
