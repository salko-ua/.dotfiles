# Systemd user services for setup that cannot be expressed declaratively --
# typically a tool that only writes its config through its own CLI.
#
# These run on every login rather than once, which is the point: on salo-pc the
# state they write lives on the wiped root, so it has to be recreated each boot.
# Commands must therefore be idempotent.
{
  lib,
  config,
  ...
}: let
  cfg = config.my.setup-stuff;
  enabledServices = lib.filterAttrs (_: v: v.enable) cfg;
in {
  options.my.setup-stuff = lib.mkOption {
    description = "Attribute set of simple objects to create systemd service for setting up some stuff.";
    default = {};
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        enable =
          (lib.mkEnableOption "this service")
          // {
            default = true;
            example = false;
          };
        command = lib.mkOption {type = lib.types.str;};
      };
    });
  };

  config.systemd.user.services =
    lib.concatMapAttrs (name: {command, ...}: {
      "setup-${name}" = {
        Unit = {
          Description = "Set up ${name}";
          # 3 total retries: the command may depend on files home-manager's own
          # activation has not finished writing when the user session starts.
          StartLimitIntervalSec = 0;
          StartLimitBurst = 3;
        };

        Install.WantedBy = ["default.target"];

        Service = {
          Type = "oneshot";
          RestartSec = 5;
          Restart = "on-failure";
          ExecStart = command;
          RemainAfterExit = true;
        };
      };
    })
    enabledServices;
}
