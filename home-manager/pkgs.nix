{ pkgs, ... }:
{
  gtk.enable = true;

  programs = {
    home-manager.enable = true;
    neovim.enable = true;
    alacritty.enable = true;
    bash.enable = false;
    fish.enable = true;
  };

  home.packages = with pkgs; [
    zip
    git
    baobab  
  ];
}
