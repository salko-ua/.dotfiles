let
  nameservers = [
    # OpenDNS
    "208.67.222.222"
    # Cloudflare
    "1.1.1.1"
    # NextDNS
    "45.90.28.0"
    # Quad9
    "9.9.9.9"
  ];
in {
  networking.nameservers = nameservers;
}
