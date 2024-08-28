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
      obs-studio # obs-studio

      # Dev
      poetry
      python3
      nodejs_22

      # IDE
      jetbrains.pycharm-professional
      jetbrains.webstorm
      zed-editor

      #kde
      filelight
      kcalc

      # Office
      libreoffice-qt
      hunspell
      hunspellDicts.uk_UA
      hunspellDicts.en_US

      # widgets
      kdePackages.qtwebengine

      pavucontrol # Sound manager

      gnumake
      gcc
      unzip
      ripgrep     
    ];
  };

}

