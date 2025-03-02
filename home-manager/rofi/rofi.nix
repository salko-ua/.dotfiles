{ pkgs, lib, ... }:
{
  programs.rofi = {
    enable = true;
    plugins = with pkgs; [ rofi-calc rofi-emoji ];
    package = pkgs.rofi-wayland;
    extraConfig = {
      modi = "drun,ssh,run";
      display-drun = "Apps ";
      display-run = "Run ";
      display-ssh = "Ssh ";
      drun-display-format = "{icon} {name}";
      show-icons = true;
      sidebar-mode = true;
      ssh-client = "alacritty ssh";
      terminal = "alacritty";
    };
  };
}
