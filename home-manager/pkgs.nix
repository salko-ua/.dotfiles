{pkgs, ...}: {

  programs = {
    home-manager.enable = true;
    alacritty.enable = true;
    bash.enable = false;
    java.enable = true;
    spotify-player.enable = true;
    gh.enable = true;
    nix-index-database.comma.enable = true;
    btop.enable = true;
    direnv.nix-direnv.enable = true;
    direnv.enable = true;
    gpg.enable = true;
  };

  home.sessionPath = ["$HOME/.local/bin"];

  home.packages = with pkgs; [
    # nvim plugins
    vimPlugins.nvim-dbee
    lenovo-legion
    nvidia-container-toolkit

    # KDE THEME
    bibata-cursors
    papirus-icon-theme
    utterly-round-plasma-style

    qbittorrent # qbittorent
    vesktop # Discord
    telegram-desktop # Telegram
    anydesk
    flatpak
    nvtopPackages.full
    xclip
    zoom-us

    # Dev
    # poetry
    uv
    python3
    nodejs_22

    # Tools
    lshw
    yt-dlp

    # IDE
    mycli
    neovim

    #kde
    kdePackages.filelight
    kdePackages.kcalc
    kdePackages.qtwebengine
    kdePackages.isoimagewriter
    kdePackages.dragon

    # Office
    libreoffice-qt
    hunspell
    hunspellDicts.uk_UA
    hunspellDicts.en_US

    # tools
    mangohud
    pavucontrol
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
