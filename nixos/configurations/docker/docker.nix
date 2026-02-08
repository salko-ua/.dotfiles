{pkgs, ...}: {
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = false;
    enableOnBoot = false;
    package = pkgs.docker_25;
    enableNvidia = true;
  };
}
