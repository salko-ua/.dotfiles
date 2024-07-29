{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment = {
    sessionVariables = {
      # IF YOUR CURSOR BECOME INVISIBLE
      WLR_NO_HARDWARE_CURSORS = "1";
      # HINT ELECTRON APPS TO USE WAYLAND
      NIXOS_OZONE_WL = "1";
    };
    systemPackages = [
      pkgs.home-manager
      pkgs.vesktop
      pkgs.discord
      pkgs.nautilus
      pkgs.telegram-desktop
      
      pkgs.swaybg
      pkgs.pavucontrol
      pkgs.waybar
      pkgs.eww
      pkgs.dunst
      pkgs.libnotify
      pkgs.swww
    ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware = {
    # MOST WAYLAND COMPOSITORS NEED THIS
    nvidia.modesetting.enable = true;
  };

}

