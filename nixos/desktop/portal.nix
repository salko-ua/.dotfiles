{
  xdg.portal = {
    enable = true;

    # extraPortals deliberately does not list xdg-desktop-portal-kde: the
    # plasma6 module already adds it, and listing it again put it in the list
    # twice, which dbus-broker logs on every start as
    #   Ignoring duplicate name 'org.freedesktop.impl.portal.desktop.kde'
    #
    # xdg-desktop-portal-gtk also ends up installed regardless, and with no
    # portals.conf either backend may answer org.freedesktop.impl.portal.Settings
    # -- which is where libadwaita and Electron apps read the dark/light
    # preference, so it decided the theme by coin flip. Pin kde so the answer is
    # deterministic and follows the Plasma colour scheme rather than a GNOME
    # default of "no preference" (which renders light).
    config.common.default = ["kde"];
  };
}
