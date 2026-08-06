{
  config,
  pkgs,
  ...
}: {
  i18n.inputMethod = {
    # Available since NixOS 24.11
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      ignoreUserConfig = true; # Use settings below, ignore user config
      addons = with pkgs; [
        fcitx5-mozc # Japanese input method
      ];
      settings = {
        globalOptions = {
          Hotkey = {
            TriggerKeys = "";
            EnumerateWithTriggerKeys = "False";
          };
          "Hotkey/EnumerateForwardKeys" = {
            "0" = "Control+Shift_L";
            "1" = "Control+Shift_R";
          };
          "Hotkey/EnumerateGroupForwardKeys"."0" = "Control+space";
        };
        inputMethod = {
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "keyboard-us";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "keyboard-ua";
          "Groups/1" = {
            Name = "Japanese";
            "Default Layout" = "us";
            DefaultIM = "mozc";
          };
          "Groups/1/Items/0".Name = "mozc";
          GroupOrder = {
            "0" = "Default";
            "1" = "Japanese";
          };
        };
      };
    };
  };
}
