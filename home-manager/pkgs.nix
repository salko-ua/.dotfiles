{pkgs, ...}: {
  programs = {
    home-manager.enable = true;
    neovim.enable = true;
    alacritty.enable = true;
    bash.enable = false;
    fish.enable = true;
    java.enable = true;
  };

  home.packages = with pkgs; [
    # KDE THEME
    bibata-cursors
    papirus-icon-theme
    utterly-round-plasma-style

    # Minecraft
    prismlauncher
   
    zip
    git
    baobab
  ];
}
