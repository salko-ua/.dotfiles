{pkgs, ...}: {
  home.packages = with pkgs; [
    xclip
    unzip
    fzf
    ripgrep
    lshw
    yt-dlp
    nvtopPackages.full
    pavucontrol
  ];
}
