{
  pkgs,
  lib,
  ...
}: {
  imports = [./ublock-origin.nix];

  programs.firefox = {
    configPath = ".config/mozilla/firefox";
    profiles.default.extensions.force = true;
    enable = true;
  };
}
