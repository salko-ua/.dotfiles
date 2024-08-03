{pkgs, ...}: {
  # ENABLE AUTO LOGIN
  services.displayManager.autoLogin = {
    enable = true;
    user = "salo";
  };
  
  nixpkgs.config.allowUnfree = true;
  
  security.polkit.enable = true;
  
  hardware.bluetooth.enable = false;
  hardware.bluetooth.powerOnBoot = false;

  services.xserver = {
    enable = true;
    excludePackages = [pkgs.xterm];
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  fonts = {
    packages = with pkgs; [
      meslo-lgs-nf
      fantasque-sans-mono
    ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Kyiv";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "uk_UA.UTF-8";
    LC_IDENTIFICATION = "uk_UA.UTF-8";
    LC_MEASUREMENT = "uk_UA.UTF-8";
    LC_MONETARY = "uk_UA.UTF-8";
    LC_NAME = "uk_UA.UTF-8";
    LC_NUMERIC = "uk_UA.UTF-8";
    LC_PAPER = "uk_UA.UTF-8";
    LC_TELEPHONE = "uk_UA.UTF-8";
    LC_TIME = "uk_UA.UTF-8";
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
      xdg-desktop-portal-kde
    ];
  };
   
}
