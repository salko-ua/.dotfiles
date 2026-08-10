{
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  networking.hostName = "salo";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";

  # TEMP: dead config (NixOS never reads this grub variable; modesetting comes
  # from hardware.nvidia modprobe params). Kept so this commit's closure is
  # byte-identical to the pre-split one; removed in the follow-up commit.
  boot.loader.grub.extraConfig = ''
    GRUB_CMDLINE_LINUX_DEFAULT="nvidia-drm.modeset=1"
  '';
}
