{pkgs, ...}: {
  # gtk.enable = true;
  home.sessionVariables = {
    # Run Electron apps natively on Wayland
    # See https://nixos.wiki/wiki/Wayland#Electron_and_Chromium
    NIXOS_OZONE_WL = "1";
  };

  programs = {
    home-manager.enable = true;
    neovim.enable = true;
    alacritty.enable = true;
    bash.enable = false;
    fish.enable = true;
    gnome-terminal.enable = false;
    firefox.enable = true;
  };

  home.packages = with pkgs; [
    zip
    git
    baobab
  ];
}
