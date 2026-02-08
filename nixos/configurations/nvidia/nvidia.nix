{
  config,
  pkgs,
  ...
}: {
  # Environment variables

  # Force wayland when possible
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Fix disappearing cursor on Hyprland
  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

  # Virtualization
  hardware.nvidia-container-toolkit.enable = true;
  #hardware.nvidia.dynamicBoost.enable = true;

  # Enable NVIDIA
  services.xserver.videoDrivers = ["nvidia"];
  hardware.graphics = {
    enable = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    #prime = {
    #  sync.enable = true;
    #  intelBusId = "PCI:0:2:0";
    #  nvidiaBusId = "PCI:1:0:0";
    #};
  };
}
