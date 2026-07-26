{
  # Force wayland when possible
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Fix disappearing cursor on Hyprland
  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
}
