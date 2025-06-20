{pkgs, ...}: {
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = false;
    enableOnBoot = false;
  };
}
