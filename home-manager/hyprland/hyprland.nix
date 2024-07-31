{
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
    systemd.enable = true;
  };

  programs = {
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

  programs.waybar = {
    enable = true;
    settings.mainBar = lib.mkMerge [
      (builtins.fromJSON (builtins.readFile ./config.json))
      {
        "hyprland/language" = {
          on-scroll-up = pkgs.writeShellScript "switch-layout-next" ''
            hyprctl devices -j | jq '.keyboards[] | select(.main).name' | xargs -I % hyprctl switchxkblayout % prev
          '';
          on-scroll-down = pkgs.writeShellScript "switch-layout-prev" ''
            hyprctl devices -j | jq '.keyboards[] | select(.main).name' | xargs -I % hyprctl switchxkblayout % next
          '';
        };
      }
    ];
    style = builtins.readFile ./style.css;
    systemd.enable = true;
  };

  wayland.windowManager.hyprland.settings = {
    env = [
      # Nvidia
      "LIBVA_DRIVER_NAME,nvidia"
      "XDG_SESSION_TYPE,wayland"
      "GBM_BACKEND,nvidia-drm"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
    ];

    exec-once = [
      "[workspace 1 ] alacritty"
      "[workspace 3 ] firefox"
    ];

    general = {
      no_border_on_floating = true;
      gaps_in = 5;
      gaps_out = 10;
      "col.inactive_border" = "rgb(7987a1)";
      "col.active_border" = "rgb(9697e8)";
      resize_on_border = true;
      hover_icon_on_border = true;
    };

    decoration = {
      rounding = 20;
      active_opacity = 1;
      inactive_opacity = 0.8;
      fullscreen_opacity = 1;
      drop_shadow = true;
      shadow_range = 10;
      "col.shadow" = "rgb(060606)";
      blur = {
        enabled = true;
        size = 2;
        new_optimizations = true;
      };
    };

    input = {
      sensitivity = -0.05;
      kb_layout = "us, ua";
      kb_options = grp:alt_shift_toggle;
    };

    windowrule = [
      "float,^(Rofi)$"
      "center 1,^(Rofi)$"
      "pin,^(Rofi)$"
      "stayfocused,^(Rofi)$"
    ];

    windowrulev2 = [
      "forcergbx, class:firefox"
      "suppressevent maximize, class:.*"

      "float,class:(steam),title:(Friends List)"
      "center,class:(steam),title:(Friends List)"

      "float,class:(pavucontrol),titile:(pavucontrol)"
      "center,class:(pavucontrol),titile:(pavucontrol)"

      "workspace 4,class:(steam),title:(Friends List)"
    ];

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
      "$mode, S, togglespecialworkspace, magic"
      "ALT CTRL, Z, workspace, 3"
      "ALT CTRL, X, workspace, 4"
      "ALT CTRL, С, workspace, 5"

      # Move window to workspace [1-10 and Special]
      "$mod SHIFT, 1, movetoworkspacesilent, 1"
      "$mod SHIFT, 2, movetoworkspacesilent, 2"
      "$mod SHIFT, 3, movetoworkspacesilent, 3"
      "$mod SHIFT, 4, movetoworkspacesilent, 4"
      "$mod SHIFT, 5, movetoworkspacesilent, 5"
      "$mod SHIFT, S, movetoworkspace, special:magic"
    ];

    bindm = [
      # Move / resize windows
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
  };
}
