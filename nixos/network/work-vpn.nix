{pkgs, ...}: {
  systemd.services.work-vpn-local-fixes = {
    wantedBy = ["multi-user.target"];
    after = ["NetworkManager.service"];
    serviceConfig.Type = "oneshot";
    script = ''
      if ${pkgs.networkmanager}/bin/nmcli connection show work-vpn >/dev/null 2>&1; then
        ${pkgs.networkmanager}/bin/nmcli connection modify work-vpn \
          +vpn.data tunnel-mtu=1350 ipv4.never-default yes
      fi
    '';
  };
}
