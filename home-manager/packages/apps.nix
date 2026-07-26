{pkgs, ...}: {
  home.packages = with pkgs; [
    qbittorrent
    telegram-desktop
    anydesk
    zoom-us
    flatpak
  ];
}
