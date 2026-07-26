{
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
