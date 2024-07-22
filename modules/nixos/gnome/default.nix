{
  services.xserver = {
    enable = true;
    displayManager = {
      gdm = {
        enable = true;
	wayland = false;
	banner = "HELLO BUDDY";
	autoSuspend = false;
      };
    };
    desktopManager.gnome.enable = true;
  };
}
