{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    bibata-cursors
    # papirus-icon-theme is pulled in by catppuccin's gtk.iconTheme as
    # catppuccin-papirus-folders (same theme, recoloured folders). Installing
    # both collides in buildEnv over share/icons/Papirus.
    utterly-round-plasma-style
  ];

  programs.plasma = {
    enable = true;
    # Only the boot-time fallback: variety overwrites this same kscreenlockerrc
    # key on every wallpaper change (change_lock_screen in its conf), so the lock
    # screen follows the desktop. Previously pointed at ./desktop_picture.jpg,
    # which does not exist in this repo -- nix never checks, since the path is
    # just interpolated into a config string, so it built fine while the greeter
    # logged "unknown wallpaper provider type" and fell back to the default.
    kscreenlocker.appearance.wallpaper = ../../nixos/desktop/theme/background.jpg;

    # A stable path, kept pointing at variety's live wallpaper by
    # variety-current-wallpaper.{service,path}. Plasma's own wallpaper setting
    # lives in plasma-org.kde.plasma.desktop-appletsrc, which is not persisted, so
    # every boot used to start on plasma's stock image until variety caught up.
    # The symlink is under .config/variety, which IS persisted, so it already
    # resolves to the last image at login. A string, not a nix path, so it stays a
    # literal path instead of being copied into the store.
    workspace.wallpaper = "/home/salo/.config/variety/current-wallpaper";
    windows.allowWindowsToRememberPositions = false;
    workspace = {
      clickItemTo = "select";
      cursor = {
        theme = "Bibata-Modern-Ice";
        size = 32;
      };
      iconTheme = "Papirus-Dark";
      splashScreen = {
        theme = "None";
      };
      windowDecorations = {
        library = "org.kde.kwin.aurorae";
        theme = "__aurorae__svg__Utterly-Round-Dark";
      };
      theme = "Utterly-Round";
      colorScheme = "BreezeDark";
    };

    hotkeys = {
      commands = {
        "launch-konsole" = {
          name = "Launch Konsole";
          key = "Alt+T";
          command = "alacritty";
        };
        "rofi" = {
          name = "start rofi";
          key = "Meta";
          command = "rofi -show drun";
        };
        "variety-previous" = {
          name = "variety previous";
          key = "Shift+Alt+P";
          command = toString (pkgs.writeShellScript "variety-previous.sh" "variety --resume && variety -p");
        };
        "variety-next" = {
          name = "variety next";
          key = "Shift+Alt+N";
          command = toString (pkgs.writeShellScript "variety-next.sh" "variety --resume && variety -n");
        };
        "variety-black" = {
          name = "variety black";
          key = "Shift+Alt+B";
          command = toString (pkgs.writeShellScript "variety-black.sh" "variety --pause && variety --set ~/Pictures/black.jpg");
        };
      };
    };

    panels = [
      {
        height = 48;
        lengthMode = "fill";
        location = "bottom";
        alignment = "center";
        hiding = "none";
        floating = true;
        widgets = [
          "org.kde.plasma.pager"
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.kickoff"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.kimpanel"
          {
            digitalClock = {
              date.enable = false;
              time = {
                showSeconds = "always";
                format = "12h";
              };
              calendar = {
                firstDayOfWeek = "monday";
                showWeekNumbers = true;
              };
              settings = {
                appearance = {
                  fontSize = 11;
                };
              };
            };
          }
          {
            systemTray.items = {
              shown = [
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.volume"
              ];
              hidden = [
                "org.kde.plasma.keyboardlayout"
                "org.kde.plasma.battery"
                "org.kde.plasma.bluetooth"
                "org.kde.plasma.battery"
                "org.kde.plasma.notifications"
                "org.kde.kdeconnect"
                "org.kde.plasma.mediacontroller"
                "org.kde.plasma.clipboard"
              ];
            };
          }
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
      effects = {
        shakeCursor.enable = true;
        translucency.enable = true;
        minimization = {
          animation = "magiclamp";
          duration = 300;
        };
        wobblyWindows.enable = true;
        desktopSwitching.animation = "slide";
        windowOpenClose.animation = "fade";
        blur.enable = false;
      };
      virtualDesktops = {
        rows = lib.mkForce 2;
        number = lib.mkForce 4;
      };
    };

    shortcuts = {
      # Layout
      "KDE Keyboard Layout Switcher"."Switch keyboard layout to English (US)" = "Alt+Shift+E";
      "KDE Keyboard Layout Switcher"."Switch keyboard layout to Ukrainian" = "Alt+Shift+U";
      "KDE Keyboard Layout Switcher"."Switch to Last-Used Keyboard Layout" = "Alt+Shift+S";
      "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = "none";

      # Ohers
      "kwin"."Edit Tiles" = "Meta+T";
      "kwin"."Grid View" = "Meta+G";
      "kwin"."Kill Window" = "Alt+F4";
      "kwin"."Window Close" = "Meta+C";
      "kwin"."Overview" = "Meta+W";
      "kwin"."Show Desktop" = "Meta+D";
      "kwin"."MoveMouseToCenter" = "Meta+F5";
      "plasmashell"."cycle-panels" = "Meta+Space";
      "kwin"."Window Operations Menu" = "Alt+F3";
      "kwin"."view_zoom_in" = ["Meta++" "Meta+=,Meta++" "Meta+=,Zoom In"];
      "kwin"."view_zoom_out" = "Meta+-";
      "kwin"."Switch One Desktop Down" = "Alt+F";
      "kwin"."Switch One Desktop Up" = "Alt+R";
      "kwin"."Switch One Desktop to the Left" = "Alt+Q";
      "kwin"."Switch One Desktop to the Right" = "Alt+E";
      "kwin"."Switch to Desktop 1" = "Alt+1";
      "kwin"."Switch to Desktop 2" = "Alt+2";
      "kwin"."Switch to Desktop 3" = "Alt+3";
      "kwin"."Switch to Desktop 4" = "Alt+4";

      "kwin"."Window to Desktop 1" = "Alt+Shift+1";
      "kwin"."Window to Desktop 2" = "Alt+Shift+2";
      "kwin"."Window to Desktop 3" = "Alt+Shift+3";
      "kwin"."Window to Desktop 4" = "Alt+Shift+4";

      "kwin"."Window Quick Tile Bottom" = "Meta+Down";
      "kwin"."Window Quick Tile Bottom Left" = "none,,Quick Tile Window to the Bottom Left";
      "kwin"."Window Quick Tile Bottom Right" = "none,,Quick Tile Window to the Bottom Right";
      "kwin"."Window Quick Tile Left" = "Meta+Left";
      "kwin"."Window Quick Tile Right" = "Meta+Right";
      "kwin"."Window Quick Tile Top" = "Meta+Up";
      "kwin"."Window Quick Tile Top Left" = "none,,Quick Tile Window to the Top Left";
      "kwin"."Window Quick Tile Top Right" = "none,,Quick Tile Window to the Top Right";

      "kwin"."Window One Desktop Down" = "Meta+Ctrl+Shift+Down";
      "kwin"."Window One Desktop Up" = "Meta+Ctrl+Shift+Up";
      "kwin"."Window One Desktop to the Left" = "Meta+Ctrl+Shift+Left";
      "kwin"."Window One Desktop to the Right" = "Meta+Ctrl+Shift+Right";

      "kwin"."Walk Through Windows" = "Alt+Tab";
      "kwin"."Walk Through Windows (Reverse)" = "Alt+Shift+Tab";
      "kwin"."Walk Through Windows of Current Application" = "Alt+`";
      "kwin"."Walk Through Windows of Current Application (Reverse)" = "Alt+~";

      # important
      "org_kde_powerdevil"."Toggle Keyboard Backlight" = "Keyboard Light On/Off";
      "kcm_touchpad"."Disable Touchpad" = "Touchpad Off";
      "kcm_touchpad"."Enable Touchpad" = "Touchpad On";
      "kcm_touchpad"."Toggle Touchpad" = ["Touchpad Toggle" "Meta+Ctrl+Zenkaku Hankaku,Touchpad Toggle,Toggle Touchpad"];
      "kmix"."decrease_microphone_volume" = "Microphone Volume Down";
      "kmix"."decrease_volume" = "Volume Down";
      "kmix"."decrease_volume_small" = "Shift+Volume Down";
      "kmix"."increase_microphone_volume" = "Microphone Volume Up";
      "kmix"."increase_volume" = "Volume Up";
      "kmix"."increase_volume_small" = "Shift+Volume Up";
      "kmix"."mic_mute" = ["Microphone Mute" "Meta+Volume Mute,Microphone Mute" "Meta+Volume Mute,Mute Microphone"];
      "kmix"."mute" = "Volume Mute";
      "ksmserver"."Halt Without Confirmation" = "Meta+Alt+P";
      "ksmserver"."Log Out Without Confirmation" = "Meta+Alt+L";
      "ksmserver"."Reboot Without Confirmation" = "Meta+Alt+R";
      "ksmserver"."Lock Session" = ["Screensaver" "Meta+Ctrl+Alt+L,Meta+L" "Screensaver,Lock Session"];
      "ksmserver"."Log Out" = "mone";
      "ksmserver"."LogOut" = "none";
      "ksmserver"."Reboot" = "none";
      "ksmserver"."Shut Down" = "none";

      # disable
      "kaccess"."Toggle Screen Reader On and Off" = "none";
      "kwin"."Activate Window Demanding Attention" = "none";
      "kwin"."Cycle Overview" = [];
      "kwin"."Cycle Overview Opposite" = [];
      "kwin"."Decrease Opacity" = "none";
      "kwin"."Increase Opacity" = "none";
      "kwin"."Expose" = "none";
      "kwin"."ExposeAll" = [];
      "kwin"."ExposeClass" = "none";
      "kwin"."ExposeClassCurrentDesktop" = [];
      "kwin"."Move Tablet to Next Output" = [];
      "kwin"."MoveMouseToFocus" = "none";
      "kwin"."MoveZoomDown" = [];
      "kwin"."MoveZoomLeft" = [];
      "kwin"."MoveZoomRight" = [];
      "kwin"."MoveZoomUp" = [];
      "kwin"."Setup Window Shortcut" = "none";
      "kwin"."Suspend Compositing" = "none";

      # .........
      "kwin"."Switch Window Down" = "none";
      "kwin"."Switch Window Left" = "none";
      "kwin"."Switch Window Right" = "none";
      "kwin"."Switch Window Up" = "none";

      "kwin"."Switch to Next Desktop" = "none";
      "kwin"."Switch to Next Screen" = "none";
      "kwin"."Switch to Previous Desktop" = "none";
      "kwin"."Switch to Previous Screen" = "none";
      "kwin"."Switch to Screen 0" = "none";
      "kwin"."Switch to Screen 1" = "none";
      "kwin"."Switch to Screen 2" = "none";
      "kwin"."Switch to Screen 3" = "none";
      "kwin"."Switch to Screen 4" = "none";
      "kwin"."Switch to Screen 5" = "none";
      "kwin"."Switch to Screen 6" = "none";
      "kwin"."Switch to Screen 7" = "none";
      "kwin"."Switch to Screen Above" = "none";
      "kwin"."Switch to Screen Below" = "none";
      "kwin"."Switch to Screen to the Left" = "none";
      "kwin"."Switch to Screen to the Right" = "none";
      "kwin"."Toggle Night Color" = [];
      "kwin"."Toggle Window Raise/Lower" = "none";

      "kwin"."Walk Through Windows Alternative" = "none";
      "kwin"."Walk Through Windows Alternative (Reverse)" = "none";
      "kwin"."Walk Through Windows of Current Application Alternative" = "none";
      "kwin"."Walk Through Windows of Current Application Alternative (Reverse)" = "none";
      "kwin"."Window Above Other Windows" = "none";
      "kwin"."Window Below Other Windows" = "none";
      "kwin"."Window Grow Horizontal" = "none";
      "kwin"."Window Grow Vertical" = "none";
      "kwin"."Window Lower" = "none";
      "kwin"."Window Maximize" = "none";
      "kwin"."Window Maximize Horizontal" = "none";
      "kwin"."Window Maximize Vertical" = "none";
      "kwin"."Window Minimize" = "";
      "kwin"."Window Move" = "none";
      "kwin"."Window Move Center" = "none";
      "kwin"."Window No Border" = "none";
      "kwin"."Window On All Desktops" = "none";
      "kwin"."Window One Screen Down" = "none";
      "kwin"."Window One Screen Up" = "none";
      "kwin"."Window One Screen to the Left" = "none";
      "kwin"."Window One Screen to the Right" = "none";
      "kwin"."Window Pack Down" = "none";
      "kwin"."Window Pack Left" = "none";
      "kwin"."Window Pack Right" = "none";
      "kwin"."Window Pack Up" = "none";
      "kwin"."Window Raise" = "none";
      "kwin"."Window Resize" = "none";
      "kwin"."Window Shade" = "none";
      "kwin"."Window Shrink Horizontal" = "none";
      "kwin"."Window Shrink Vertical" = "none";
      #"kwin"."Window to Desktop 1" = "none";
      #"kwin"."Window to Desktop 2" = "none"; USED
      #"kwin"."Window to Desktop 3" = "none";
      #"kwin"."Window to Desktop 4" = "none";
      "kwin"."Window to Desktop 5" = "none";
      "kwin"."Window to Desktop 6" = "none";
      "kwin"."Window to Desktop 7" = "none";
      "kwin"."Window to Desktop 8" = "none";
      "kwin"."Window to Desktop 9" = "none";
      "kwin"."Window to Desktop 10" = "none";
      "kwin"."Window to Desktop 11" = "none";
      "kwin"."Window to Desktop 12" = "none";
      "kwin"."Window to Desktop 13" = "none";
      "kwin"."Window to Desktop 14" = "none";
      "kwin"."Window to Desktop 15" = "none";
      "kwin"."Window to Desktop 16" = "none";
      "kwin"."Window to Desktop 17" = "none";
      "kwin"."Window to Desktop 18" = "none";
      "kwin"."Window to Desktop 19" = "none";
      "kwin"."Window to Desktop 20" = "none";

      "kwin"."Window to Next Desktop" = "none";
      "kwin"."Window to Next Screen" = "none";
      "kwin"."Window to Previous Desktop" = "none";
      "kwin"."Window to Previous Screen" = "none";
      "kwin"."Window to Screen 0" = "none";
      "kwin"."Window to Screen 1" = "none";
      "kwin"."Window to Screen 2" = "none";
      "kwin"."Window to Screen 3" = "none";
      "kwin"."Window to Screen 4" = "none";
      "kwin"."Window to Screen 5" = "none";
      "kwin"."Window to Screen 6" = "none";
      "kwin"."Window to Screen 7" = "none";
      "kwin"."view_actual_size" = "none";

      "org_kde_powerdevil"."Turn Off Screen" = [];
      "org_kde_powerdevil"."powerProfile" = [];
      "plasmashell"."activate application launcher" = [];
      "plasmashell"."activate task manager entry 1" = "none";
      "plasmashell"."activate task manager entry 2" = "none";
      "plasmashell"."activate task manager entry 3" = "none";
      "plasmashell"."activate task manager entry 4" = "none";
      "plasmashell"."activate task manager entry 5" = "none";
      "plasmashell"."activate task manager entry 6" = "none";
      "plasmashell"."activate task manager entry 7" = "none";
      "plasmashell"."activate task manager entry 8" = "none";
      "plasmashell"."activate task manager entry 9" = "none";
      "plasmashell"."activate task manager entry 10" = "none";
      "plasmashell"."clear-history" = "none";
      "plasmashell"."clipboard_action" = "none";
      "plasmashell"."cycleNextAction" = "none";
      "plasmashell"."cyclePrevAction" = "none";
      "plasmashell"."manage activities" = "Meta+A";
      "plasmashell"."next activity" = "none";
      "plasmashell"."previous activity" = "none";
      "plasmashell"."repeat_action" = "none";
      "plasmashell"."show dashboard" = "none";
      "plasmashell"."show-barcode" = "none";
      "plasmashell"."show-on-mouse-pos" = "none";
      "plasmashell"."stop current activity" = "none";
      "plasmashell"."switch to next activity" = "Meta+A+E";
      "plasmashell"."switch to previous activity" = "Meta+A+Q";
      "plasmashell"."toggle do not disturb" = "none";
    };
    configFile = {
      "ksmserverrc"."General"."loginMode" = "emptySession";
      "kwalletrc"."Wallet"."Enabled" = true;
      # KDE's "Virtual Keyboard" setting. nixos/desktop/japanese.nix runs fcitx5
      # with waylandFrontend, which deliberately leaves GTK_IM_MODULE/QT_IM_MODULE
      # unset -- the compositor's input-method protocol is then the only input
      # path, and KWin only offers it to whatever this points at. Unset means
      # fcitx5 comes up, loads its addons, then logs "Using Wayland native input
      # method protocol: 0" and never receives a keystroke.
      #
      # The launcher is a small D-Bus client that hands KWin's input-method fd to
      # the already-running org.fcitx.Fcitx5, so this does not start a second
      # daemon and the existing XDG autostart stays as it is. Deliberately the
      # /run/current-system path, not a store path: it stays valid across
      # rebuilds and always matches the fcitx5 build systemPackages installed.
      "kwinrc"."Wayland"."InputMethod" = "/run/current-system/sw/share/applications/fcitx5-wayland-launcher.desktop";
      "kwinrc"."Xwayland"."Scale" = 1;
      "kxkbrc"."Layout"."DisplayNames" = ",";
      "kxkbrc"."Layout"."LayoutList" = "us,ua";
      "kxkbrc"."Layout"."Use" = true;
      "kxkbrc"."Layout"."VariantList" = ",";
      "plasma-localerc"."Formats"."LANG" = "en_US.UTF-8";
    };
  };
}
