{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = import ../lib/auto-import.nix ./.;

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
      inputs.self.overlays.additions
      inputs.self.overlays.modifications
      inputs.self.overlays.unstable-packages
    ];
  };

  home = {
    username = "salo";
    homeDirectory = "/home/salo";
  };

  services.arrpc.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
