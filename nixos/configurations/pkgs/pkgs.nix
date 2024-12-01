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
      logmein-hamachi
      zerotierone
      flatpak
      gnufdisk
      variety
      nvtop

      # Dev
      poetry
      python312Packages.ipython
      python312Packages.greenlet
      python3
      nodejs_22

      # Tools
      lshw
      steamguard-cli
      yt-dlp

      # IDE
      jetbrains.pycharm-professional
      jetbrains.webstorm
      mycli

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
      kdePackages.isoimagewriter
      dragon
      mangohud

      pavucontrol # Sound manager
      gnumake
      gcc
      unzip
      ripgrep
    ];
  };

}

