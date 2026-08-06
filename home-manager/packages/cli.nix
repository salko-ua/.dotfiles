{pkgs, ...}: {
  home.packages = with pkgs; [
    xclip
    wl-clipboard
    unzip
    fzf
    ripgrep
    lshw
    yt-dlp
    nvtopPackages.full
    pavucontrol
  ];
}
