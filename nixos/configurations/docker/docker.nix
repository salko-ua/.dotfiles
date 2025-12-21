{pkgs, ...}: {
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = false;
    enableOnBoot = false;
    package = pkgs.docker_25;
  };

  hardware.nvidia-container-toolkit.enable = true;
}
