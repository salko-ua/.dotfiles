{ pkgs, ... }:
{
  home.packages = [ pkgs.variety ];

  xdg.configFile = {
    "variety/ui.conf".source = ./ui.conf;
  };

  home.file."Pictures/.keep".text = "Variety needs this";
}
