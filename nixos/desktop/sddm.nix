{
  # Unlock kwallet automatically with the login password.
  security.pam.services.sddm.kwallet.enable = true;

  services.displayManager = {
    defaultSession = "plasma";
    autoLogin = {
      enable = false;
      user = "salo";
    };
    sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
}
