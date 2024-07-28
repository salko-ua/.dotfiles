{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
    systemd.enable = true;
  };

  programs = {
      waybar.enable = true;
      rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
	extraConfig = {
          modes = "drun";
          show-icons = true;
        };
      };
      hyprlock.enable = true;
      wlogout.enable = true;
    };

  wayland.windowManager.hyprland.settings = {
    decoration = {
      shadow_offset = "0 5";
      "col.shadow" = "rgba(00000099)";
    };

    input = {
      sensitivity = -0.05;
      kb_layout = "us, ua";
      kb_options=grp:caps_toggle;
    };

    monitor = "eDP-1, 2560x1440@165, 0x0, 1.600000";    

    "$mod" = "SUPER";
    "$terminal" = "alacritty";
    "$fileManager" = "nautilus";
    "$menu" = "rofi -show drun";

    bind = [
      # Run program
      "$mod, F, exec, firefox"
      "$mod, T, exec, alacritty"
      "$mod, D, exec, vesktop"
      "$mod, M, exec, $fileManager"
      "$mod, V, togglefloating"
      "$mod, R, exec, $menu"

      # Exit && Force exit
      "$mod, C, killactive"
      #"$mod, M, exit"

      # Workspace movement
      "$mod, Q, workspace, e-1"
      "$mod, E, workspace, e+1"
      "$mod, S, togglespecialworkspace, magic"

      # Move window to workspace [1-10 and Special]
      "$mod SHIFT, 1, movetoworkspace, 1"
      "$mod SHIFT, 2, movetoworkspace, 2"
      "$mod SHIFT, 3, movetoworkspace, 3"
      "$mod SHIFT, 4, movetoworkspace, 4"
      "$mod SHIFT, 5, movetoworkspace, 5"
      "$mod SHIFT, 6, movetoworkspace, 6"
      "$mod SHIFT, 7, movetoworkspace, 7"
      "$mod SHIFT, 8, movetoworkspace, 8"
      "$mod SHIFT, 9, movetoworkspace, 9"
      "$mod SHIFT, 0, movetoworkspace, 10"
      "$mod SHIFT, S, movetoworkspace, special:magic"

    ];

    bindm = [
      # Move / resize windows
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];

    windowrule = [
      "float,^(Rofi)$"
      "center 1,^(Rofi)$"
      "pin,^(Rofi)$"
    ];
  };
}

