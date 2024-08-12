{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # modules from  modules/home-manager):
    # outputs.homeManagerModules.git

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    ./pkgs.nix
    ./plasma/plasma.nix
    #./hyprland/hyprland.nix
    ./theme/theme.nix
    ./terminal/fish.nix
    ./terminal/alacritty.nix
    ./firefox/firefox.nix
    ./git/git.nix
  ];

  

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "salo";
    homeDirectory = "/home/salo";
  };
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
