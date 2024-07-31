{ pkgs, lib, ... }:
{
  programs.plasma = {
    enable = true;
    kscreenlocker.wallpaper = ./home_night.png;
    windows.allowWindowsToRememberPositions = true;
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
	theme = null;
      };
      windowDecorations = {
	library = "org.kde.kwin.aurorae";
	theme="__aurorae__svg__Utterly-Round-Dark";
      };
    };

    hotkeys = {
      commands = {
        "launch-konsole" = {
          name = "Launch Konsole";
          key = "Alt+T";
          command = "alacritty";
        };
      };
    };

    panels = [
      # Windows-like panel at the bottom
      {
        height = 50;
	lengthMode = "fill";
        location = "bottom";
	alignment = "center";
	hiding = "dodgewindows";
	floating = true;
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
	  "org.kde.plasma.pager"
	  "org.kde.plasma.showdesktop"
        ];
      }
    ];
    

    # Screen saver
    spectacle.shortcuts = {
      captureActiveWindow = null;
      captureCurrentMonitor = null;
      captureEntireDesktop = null;
      captureRectangularRegion = "Print";
      captureWindowUnderCursor = null;
      launch = "Meta+S";
      launchWithoutCapturing = "Meta+Shift+S";
      recordRegion = null;
      recordScreen = null;
      recordWindow = null;
    };
    
    kwin = {
      titlebarButtons.right = ["minimize" "maximize" "close"];
      titlebarButtons.left = ["help" "keep-above-windows"];
      effects = {
	shakeCursor.enable = false;
	translucency.enable = true;
	minimization = {
	  animation = "magiclamp";
	  duration = 50;
	};
	wobblyWindows.enable = true;
	desktopSwitching.animation = "slide";
	windowOpenClose.animation = "fade";
	blur.enable = true;
      };
      virtualDesktops = {
          rows = 2;
          number = lib.mkForce 6;
      };
      borderlessMaximizedWindows = true;
      edgeBarrier = 10;
    };

    
    shortcuts = {
      ksmserver = {
        "Lock Session" = [ "Screensaver" "Meta+Ctrl+Alt+L" ];
      };

      kwin = {
        "Expose" = "Meta+,";
      };
      KeyboardLayoutSwitcher = {
      	"Switch to Next Keyboard Layout" = "Alt+Shift";
      };
    };




    #
    # Some low-level settings:
    #
    configFile = {
      "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
    };
  };
}
