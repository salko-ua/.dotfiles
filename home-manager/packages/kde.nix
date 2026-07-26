{pkgs, ...}: {
  home.packages = with pkgs; [
    kdePackages.filelight
    kdePackages.kcalc
    kdePackages.qtwebengine
    kdePackages.isoimagewriter
    kdePackages.dragon
  ];
}
