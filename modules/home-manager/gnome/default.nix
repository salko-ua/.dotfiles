{
  pkgs,
  ...
}: 
let
  extensions = with pkgs.gnomeExtensions; [
    blur-my-shell
    compiz-alike-magic-lamp-effect
    compiz-windows-effect
    dash-to-panel
    tray-icons-reloaded
    caffeine
    appindicator
    burn-my-windows
    tiling-assistant
    quick-lang-switch
  ];
in
{
  dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = map (extension: extension.extensionUuid) extensions;
      };

      "org/gnome/shell/extensions/blur-my-shell/applications" = {
        blur = false;
      };
      "org/gnome/shell/extensions/burn-my-windows" = {
        show-support-dialog = false;
        last-prefs-version = 39;
      };
      "org/gnome/shell/extensions/ncom/github/hermes83/compiz-alike-magic-lamp-effect" = {
        duration = 350.0;
        x-tiles = 15.0;
        y-tiles = 15.0;
      };
      "org/gnome/shell/extensions/com/github/hermes83/compiz-windows-effect" = {
        speedup-factor-divider = 22.0;
        mass = 20.0;
        resize-effect = true;
      }; 
      "org/gnome/shell/extensions/trayIconsReloaded" = {
        invoke-to-workspace = false;
      };
  };
}
