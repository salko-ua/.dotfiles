{pkgs, ...}: {
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  documentation.nixos.enable = false;

  environment.plasma6.excludePackages =
    (with pkgs; [
      baobab
      xterm
    ])
    ++ (with pkgs.kdePackages; [
      plasma-browser-integration
      konsole
      oxygen
      elisa
      okular
    ]);
}
