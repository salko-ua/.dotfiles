{ pkgs, ... }:
{
  systemd.user.services = {
    setup-obs-microphone = {
      Unit = {
        After = [
          "pipewire.service"
          "pipewire-pulse.service"
        ];
        StartLimitIntervalSec = 0;
        StartLimitBurst = 3;
      };
      Install.WantedBy = [ "default.target" ];
      Service = {
        Type = "oneshot";
        RestartSec = 5;
        Restart = "on-failure";
        ExecStart = pkgs.writeShellScript "setup-obs-microphone.sh" ''
          pactl load-module module-null-sink media.class=Audio/Sink sink_name=Virtual-Mic channel_map=front-left,front-right
          pactl load-module module-null-sink media.class=Audio/Source/Virtual sink_name=Virtual-Mic channel_map=front-left,front-right
          pw-link Virtual-Mic:monitor_FL Virtual-Mic:input_FL
          pw-link Virtual-Mic:monitor_FR Virtual-Mic:input_FR
        '';
        RemainAfterExit = true;
      };
    };
  };
}
