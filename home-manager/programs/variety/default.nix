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

    # variety writes this itself when its "run at startup" option is set, which
    # would launch a second copy alongside the service below. Hidden=true is how
    # the XDG autostart spec says to ignore an entry.
    "autostart/variety.desktop" = {
      force = true;
      text = ''
        [Desktop Entry]
        Type=Application
        Name=Variety
        Comment=Superseded by the variety.service user unit
        Exec=${pkgs.variety}/bin/variety
        Hidden=true
      '';
    };
  };

  # A user service rather than an autostart entry, which drops the `bash -c
  # "sleep 20 && variety"` wrapper variety writes for itself. That 20s delay is
  # why the plain Plasma wallpaper was visible for the first 20 seconds of every
  # session.
  #
  # Ordering after plasma-plasmashell is the actual requirement the sleep was
  # standing in for: plasmashell owns the system tray, and variety is a tray app.
  # The short ExecStartPre remains because "plasmashell started" is not quite
  # "tray accepting clients"; 3s is enough and 20s never was necessary.
  systemd.user.services.variety = {
    Unit = {
      Description = "Variety wallpaper changer";
      After = ["graphical-session.target" "plasma-plasmashell.service"];
      PartOf = ["graphical-session.target"];
    };

    Install.WantedBy = ["graphical-session.target"];

    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
      ExecStart = "${pkgs.variety}/bin/variety --profile ${config.xdg.configHome}/variety/";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  # Keeps ~/.config/variety/current-wallpaper pointing at the live wallpaper, so
  # plasma-manager has a stable path to aim the desktop wallpaper at (see
  # programs.plasma.workspace.wallpaper). Without it, plasma's own wallpaper
  # setting lives in the unpersisted desktop-appletsrc and every boot starts on
  # plasma's stock image until variety changes it.
  systemd.user.services.variety-current-wallpaper = {
    Unit.Description = "Point a stable path at variety's current wallpaper";
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash ${./current-wallpaper.sh}";
    };
  };

  # variety rewrites wallpaper.jpg.txt on every change, so watching that one file
  # is enough -- no polling.
  systemd.user.paths.variety-current-wallpaper = {
    Unit.Description = "Watch variety's current-wallpaper record";
    Path.PathChanged = "%h/.config/variety/wallpaper/wallpaper.jpg.txt";
    Install.WantedBy = ["graphical-session.target"];
  };

  home.file."Pictures/.keep".text = "Variety needs this";
}
