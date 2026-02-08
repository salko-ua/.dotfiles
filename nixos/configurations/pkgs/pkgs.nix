{pkgs, ...}: {
  programs = {
    partition-manager.enable = true;
    kdeconnect.enable = true;
  };
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];
  services.xserver.wacom.enable = true;
  environment = {
    sessionVariables = {
      NH_FLAKE = "/home/salo/.dotfiles";
    };
    systemPackages = with pkgs; [
      home-manager # Generations manager
      nh
      cargo
      kdePackages.wacomtablet
    ];
  };
}
