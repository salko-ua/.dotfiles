{pkgs, ...}: {
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  documentation.nixos.enable = false;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-photos
      gnome-tour
      gnome-connections
      gnome-console
      gnome-text-editor
      xterm
      xtermcontrol
      gedit
      loupe # image viewer
      baobab # disk usage analayzer
    ])
    ++ (with pkgs.gnome; [
      gnome-font-viewer
      gnome-maps
      gnome-contacts
      gnome-weather
      gnome-calculator
      gnome-music
      gnome-terminal
      gnome-characters
      file-roller # archived files file-roller
      simple-scan # document scanner
      epiphany # web browser
      geary # email reader
      evince # document viewer
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      cheese # camera
      yelp # help
      seahorse # passwords and keys
    ]);

  programs.dconf.enable = true;
}
