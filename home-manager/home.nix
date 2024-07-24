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
    outputs.homeManagerModules.git 
    outputs.homeManagerModules.gnome
    
    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    ./pkgs.nix
    ./fish.nix
    ./alacritty.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      ];
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
