{pkgs, ...}: {
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasmax11";
  hardware.pulseaudio.enable = false;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    kwallet
    konsole
    oxygen
    kwalletmanager
  ];

  programs.dconf.enable = true;
}
