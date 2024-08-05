{ pkgs, ... }:
{
  programs = {
    partition-manager.enable = true;
    kdeconnect.enable = true;
    #hyprland = {
    #  enable = true;
    #  xwayland.enable = true;
    #  systemd.setPath.enable = true;
    #};
  };

  environment = {
    systemPackages = with pkgs; [
      home-manager # Generations manager
      vesktop # Discord
      discord # Discord
      telegram-desktop # Telegram
      wineWowPackages.stable # wine
      winetricks
      bitwarden # bitwarden

      #kde
      filelight
      kcalc

      #swaybg # Wallpaper manager
      pavucontrol # Sound manager
      #waybar # Waybar for hyprland
      #eww # ...
      #dunst # ...
      #libnotify # ...
      #swww # ...
    ];
  };

}
