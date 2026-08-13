{
  imports = [
    ./hardware-configuration.nix
    # Wipe-on-boot root. Desktop only -- see manual-modules/README.md.
    ../../manual-modules/impermanence
  ];

  networking.hostName = "salo-pc";

  # Fresh install on 26.05 — never change after install.
  system.stateVersion = "26.05";

  # RX 9070 XT — in-kernel amdgpu, no driver packages needed.
  hardware.graphics.enable = true;
  hardware.amdgpu.initrd.enable = true; # early KMS
}
