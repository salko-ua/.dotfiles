{pkgs, ...}: {
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    lenovo-legion
    nvidia-container-toolkit
  ];

  # Nvidia hardware acceleration (plugins live in home-manager/programs/obs.nix)
  programs.obs-studio.package = pkgs.obs-studio.override {
    cudaSupport = true;
  };
}
