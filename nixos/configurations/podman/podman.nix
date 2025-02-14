{
  pkgs,
  ...
}:
{    
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  environment.systemPackages = [ pkgs.podman-compose ];
}
