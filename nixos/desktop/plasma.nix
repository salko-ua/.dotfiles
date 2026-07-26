{pkgs, ...}: {
  services.xserver.enable = true;
  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = true; #disable for qt6 full version
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    kwallet
    konsole
    oxygen
    kwalletmanager
  ];
}
