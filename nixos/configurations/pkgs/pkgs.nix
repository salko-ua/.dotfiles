{ pkgs, ... }:
{
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd.setPath.enable = true;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      home-manager # Generations manager
      vesktop # Discord
      discord # Discord
      telegram-desktop # Telegram

      swaybg # Wallpaper manager
      pavucontrol # Sound manager
      waybar # Waybar for hyprland
      eww # ...
      dunst # ...
      libnotify # ...
      swww # ...
    ];
  };

}