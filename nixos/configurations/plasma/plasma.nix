{ pkgs, ... }:
{
  services.xserver.enable = true;
  services.xserver = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
  services.displayManager.sddm.enable = false;
  services.desktopManager.plasma6.enable = false;
  services.displayManager.defaultSession = "gnome";
  # environment.plasma6.excludePackages = with pkgs.kdePackages; [
  #   plasma-browser-integration
  #   konsole
  #   oxygen
  #   kwalletmanager
  #
  # ];

  programs.dconf.enable = true;
}
