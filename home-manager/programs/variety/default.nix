{
  pkgs,
  config,
  ...
}: {
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

    # variety's own "run at startup" toggle writes this into ~/.config/autostart,
    # which on salo-pc is the wiped root, so it only ever stuck on the laptop.
    # The 20s delay is variety's own -- it waits for the network before trying to
    # fetch a wallpaper, and needs a shell for the &&. The absolute variety path
    # replaces the bare `variety` it writes, which depends on the autostart
    # environment's PATH.
    "autostart/variety.desktop" = {
      force = true; # variety writes this itself, same as the two conf files above
      text = ''
        [Desktop Entry]
        Type=Application
        Name=Variety
        Comment=Variety Wallpaper Changer
        Exec=${pkgs.bash}/bin/bash -c "sleep 20 && ${pkgs.variety}/bin/variety --profile ${config.xdg.configHome}/variety/"
        Icon=variety
        Terminal=false
        StartupNotify=false
        StartupWMClass=Variety
        Categories=GNOME;GTK;Utility;
      '';
    };
  };

  home.file."Pictures/.keep".text = "Variety needs this";
}
