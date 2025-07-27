{
  pkgs,
  lib,
  ...
}: {
  imports = [./ublock-origin.nix];

  programs.firefox = {
    profiles.default.extensions.force = true; 
    enable = true;
  };
}
