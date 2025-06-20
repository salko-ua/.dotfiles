{pkgs, ...}: {
  programs = {
    partition-manager.enable = true;
    kdeconnect.enable = true;

    #hyprland = {
    #  enable = true;
    #  xwayland.enable = true;
    #  systemd.setPath.enable = true;
    #};
  };

  environment = {
    sessionVariables = {
      NH_FLAKE = "/home/salo/.dotfiles";
    };
    systemPackages = with pkgs; [
      home-manager # Generations manager
      nh
    ];
  };
}
