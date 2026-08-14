{pkgs, ...}: {
  # easyeffects came up with a light theme every session, then looked correct if
  # restarted by hand later. It is a Qt6 app (libQt6Widgets -- it moved off
  # GTK4/libadwaita in version 8), so its palette comes from
  # KDEPlasmaPlatformTheme6, which reads the colour scheme out of kdeglobals once
  # at process start.
  #
  # plasma-manager writes that colour scheme from a session autostart entry
  # (app-plasma\x2dmanager\x2dautostart@autostart.service), i.e. during session
  # startup rather than during home-manager activation. easyeffects starts in the
  # same instant and reads kdeglobals before ColorScheme=BreezeDark is in it.
  #
  # So order it after plasmashell and give plasma-manager a moment to finish. The
  # sleep is not elegant, but the alternative is ordering against that generated,
  # escaped autostart unit name, and this daemon has no reason to start promptly.
  # Deliberately only service-to-service ordering: an earlier attempt to order
  # anything Before=graphical-session.target deadlocked the whole session.
  systemd.user.services.easyeffects = {
    Unit.After = ["plasma-plasmashell.service"];
    Service.ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
  };

  # Mic/output DSP on PipeWire. GUI: `easyeffects`, runs as background service.
  # Mic preset "mic-clean" (RNNoise): select once in GUI Input tab, it sticks.
  services.easyeffects = {
    enable = true;
    extraPresets = {
      mic-clean = {
        input = {
          blocklist = [];
          "plugins_order" = ["rnnoise#0"];
          "rnnoise#0" = {
            bypass = false;
            "enable-vad" = false;
            "input-gain" = 0.0;
            "model-name" = "";
            "output-gain" = 0.0;
            release = 20.0;
            "vad-thres" = 50.0;
            wet = 0.0;
          };
        };
      };
    };
  };
}
