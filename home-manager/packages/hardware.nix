{pkgs, ...}: {
  home.packages = with pkgs; [
    lenovo-legion
    nvidia-container-toolkit
  ];
}
