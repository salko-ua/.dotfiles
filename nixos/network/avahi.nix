# mDNS, so the hosts can find each other by name on the LAN without static
# leases: salo-pc.local <-> salo-laptop.local. networking.nameservers (see
# dns.nix) only covers public DNS, and nothing here runs systemd-resolved, so
# without this there is no .local resolution at all.
{
  services.avahi = {
    enable = true;

    # Resolve *.local in every program that uses glibc's NSS -- ssh, scp,
    # Dolphin's sftp://, curl. IPv4 only; the LAN has no IPv6.
    nssmdns4 = true;

    publish = {
      enable = true;
      addresses = true; # answer "who is salo-pc.local"
      workstation = true; # show up in Dolphin's zeroconf:/ and KDE Connect
    };

    # openFirewall defaults to true and opens UDP 5353.
  };
}
