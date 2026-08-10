{
  imports = [./hardware-configuration.nix];

  networking.hostName = "salo-pc";

  # Fresh install on 26.05 — never change after install.
  system.stateVersion = "26.05";

  # RX 9070 XT — in-kernel amdgpu, no driver packages needed.
  hardware.graphics.enable = true;
  hardware.amdgpu.initrd.enable = true; # early KMS

  # GPU fan curves / clocks — enable together after install:
  # services.lact.enable = true;
  # hardware.amdgpu.overdrive.enable = true;

  # ARGB control, once RGB fans exist:
  # services.hardware.openrgb = {
  #   enable = true;
  #   motherboard = "amd"; # loads i2c-piix4
  # };
}
