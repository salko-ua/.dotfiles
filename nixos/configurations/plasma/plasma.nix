{ pkgs, ... }:
{
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";
  hardware.pulseaudio.enable = true;
   environment.plasma6.excludePackages = with pkgs.kdePackages; [
     plasma-browser-integration
     konsole
     oxygen
     kwalletmanager
   ];

  programs.dconf.enable = true;
}
