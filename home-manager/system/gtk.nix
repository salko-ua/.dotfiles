# GTK apps were rendering light in a dark Plasma session.
#
# kde-gtk-config generates ~/.config/gtk-{3,4}.0/colors.css from the Plasma
# colour scheme, but every colour in it is named *_breeze -- they are only ever
# consumed by the Breeze GTK theme. It leaves gtk-theme-name out of settings.ini
# and writes an empty Net/ThemeName into xsettingsd.conf, so that theme never
# loads, the generated colours go unused, and GTK falls back to its built-in
# light Adwaita. Naming the theme here is what makes those colours apply.
{pkgs, ...}: {
  gtk = {
    enable = true;

    theme = {
      name = "Breeze-Dark";
      package = pkgs.kdePackages.breeze-gtk;
    };

    # iconTheme is deliberately not set here: catppuccin's gtk module already
    # points it at Papirus-Dark with catppuccin folder colours. It was being
    # ignored until now, because home-manager only writes settings.ini when
    # gtk.enable is on -- which it was not.

    # GTK3 honours this directly; GTK4/libadwaita ignores it and reads the
    # colour scheme from the desktop portal instead -- see
    # nixos/desktop/portal.nix, which pins that to the KDE backend.
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  # kde-gtk-config rewrites both files at session start, so they are ordinary
  # files rather than home-manager symlinks and activation would otherwise abort
  # with "would be clobbered" (as the autostart entries did on the laptop).
  xdg.configFile = {
    "gtk-3.0/settings.ini".force = true;
    "gtk-4.0/settings.ini".force = true;
  };
}
