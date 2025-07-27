{pkgs, ...}: {
  services = {
    xserver.enable = true;
    desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = true; #disable for qt6 full version
    };
    displayManager = {
      defaultSession = "plasma";
      autoLogin = {
        enable = true;
        user = "salo";
      };
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
  };
  services.pulseaudio.enable = false;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    kwallet
    konsole
    oxygen
    kwalletmanager
  ];

  programs.dconf.enable = true;
}
