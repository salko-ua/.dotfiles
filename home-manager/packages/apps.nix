{pkgs, ...}: {
  home.packages = with pkgs; [
    qbittorrent
    telegram-desktop
    anydesk
    unstable.bitwarden-desktop
  ];
}
