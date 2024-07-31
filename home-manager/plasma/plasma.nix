{ pkgs, ... }:
{
  programs.plasma = {
    enable = true;

    #
    # Some high-level settings:
    #
    workspace = {
      clickItemTo = "select";
      cursor = {
        theme = "Bibata-Modern-Ice";
	size = 32;
      };
      iconTheme = "Papirus-Dark";
      wallpaper = ./home_night.png;
      splashScreen = {
	engine = null;
      };
      windowDecorations = {
	library = "org.kde.kwin.aurorae";
	theme="__aurorae__svg__Utterly-Round-Dark";
      };

    };

    hotkeys.commands = {
      "launch-konsole" = {
        name = "Launch Konsole";
        key = "Alt+T";
        command = "alacritty";
      };
    };

    panels = [
      # Windows-like panel at the bottom
      {
        location = "bottom";
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
	floating = true;
      }
      # Global menu at the top
      #{
      #  location = "top";
      #  height = 26;
      #  widgets = [
      #    "org.kde.plasma.appmenu"
      #  ];
      #}
    ];


    #
    # Some mid-level settings:
    #
    shortcuts = {
      ksmserver = {
        "Lock Session" = [ "Screensaver" "Meta+Ctrl+Alt+L" ];
      };

      kwin = {
        "Expose" = "Meta+,";
        "Switch Window Down" = "Meta+J";
        "Switch Window Left" = "Meta+H";
        "Switch Window Right" = "Meta+L";
        "Switch Window Up" = "Meta+K";
      };
    };


    #
    # Some low-level settings:
    #
    configFile = {
      "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
      "kwinrc"."org.kde.kdecoration2"."ButtonsOnLeft" = "SF";
      "kwinrc"."Desktops"."Number" = {
        value = 8;
        # Forces kde to not change this value (even through the settings app).
        immutable = true;
      };
    };
  };
}
