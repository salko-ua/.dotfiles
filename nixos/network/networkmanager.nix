{pkgs, ...}: {
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "dnsmasq";
  networking.networkmanager.plugins = [pkgs.networkmanager-openvpn];
}
