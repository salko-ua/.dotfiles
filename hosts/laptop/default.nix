{
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  networking.hostName = "salo-laptop";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
