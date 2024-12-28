{
  pkgs,
  lib,
  ...
}: {
  programs.rofi = {
    enable = true;
    location = "center";
    package = pkgs.rofi-wayland;
    extraConfig = {
      modes = "drun";
      show-icons = true;
    };
  };
}
