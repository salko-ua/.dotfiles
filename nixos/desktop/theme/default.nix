{
  # Third-party Qt apps rendered with Qt's default *light* palette instead of the
  # Breeze Dark colour scheme, because QT_QPA_PLATFORMTHEME was set nowhere on
  # the system -- qt.enable was true but qt.platformTheme was null, so nothing
  # exported it. Without it Qt never loads KDEPlasmaPlatformTheme6.so and so
  # never reads kdeglobals.
  #
  # Plasma's own apps looked correct throughout because they link KDE frameworks
  # and read kdeglobals themselves; only third-party Qt apps depend on the
  # platform theme plugin. easyeffects is one of them -- it is Qt6, not
  # GTK4/libadwaita as it was before version 8, which is why none of the GTK or
  # xdg-desktop-portal colour-scheme settings ever affected it.
  qt.platformTheme = "kde";

  # grub
  catppuccin.grub.enable = true;
  catppuccin.grub.flavor = "mocha";
  catppuccin.plymouth.enable = false;
  catppuccin.plymouth.flavor = "mocha";

  # lock screen
  catppuccin.sddm.background = ./background.jpg;
  catppuccin.sddm.flavor = "mocha";
  catppuccin.sddm.fontSize = "14";
  catppuccin.sddm.loginBackground = false;
  catppuccin.enable = true;
  catppuccin.flavor = "mocha";
}
