{pkgs, ...}: {
  home.packages = [pkgs.variety];

  # variety rewrites both files at runtime, so activation must overwrite them
  xdg.configFile = {
    "variety/ui.conf" = {
      source = ./ui.conf;
      force = true;
    };
    "variety/variety.conf" = {
      source = ./variety.conf;
      force = true;
    };
  };

  home.file."Pictures/.keep".text = "Variety needs this";
}
