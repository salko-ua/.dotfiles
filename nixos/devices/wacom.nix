{pkgs, ...}: {
  services.xserver.wacom.enable = true;
  environment.systemPackages = [pkgs.kdePackages.wacomtablet];
}
