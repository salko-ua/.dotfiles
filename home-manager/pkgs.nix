{pkgs, ...}: {
  programs = {
    home-manager.enable = true;
    alacritty.enable = true;
    bash.enable = false;
    fish.enable = true;
    java.enable = true;
    spotify-player.enable = true;
    gh.enable = true;
    btop.enable = true;
  };

  home.packages = with pkgs; [
    # KDE THEME
    bibata-cursors
    papirus-icon-theme
    utterly-round-plasma-style

    # Minecraft
    prismlauncher
    neovim 
    zip
    git
  ];
}
