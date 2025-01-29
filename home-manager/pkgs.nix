{pkgs, ...}: {
  programs = {
    home-manager.enable = true;
    alacritty.enable = true;
    bash.enable = false;
    fish.enable = true;
    java.enable = true;
    spotify-player.enable = true;
    gh.enable = true;
    nix-index-database.comma.enable = true;
    btop.enable = true;
    direnv.nix-direnv.enable = true;
    direnv.enable = true;
  };

  home.packages = with pkgs; [
    # KDE THEME
    bibata-cursors
    papirus-icon-theme
    utterly-round-plasma-style

    qbittorrent # qbittorent
    vesktop # Discord
    telegram-desktop # Telegram
    wineWowPackages.stable # wine
    winetricks
    bitwarden # bitwarden
    obs-studio # obs-studio

    flatpak
    gnufdisk
    variety
    nvtopPackages.full

    # Dev
    poetry
    python312Packages.ipython
    python3
    nodejs_22

    # Tools
    lshw
    steamguard-cli
    yt-dlp

    # IDE
    jetbrains.pycharm-professional
    mycli
    neovim

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
    git
    unzip
    fzf
    ripgrep
    lazygit

    # Minecraft
    prismlauncher
  ];
}
