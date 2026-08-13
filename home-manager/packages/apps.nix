{pkgs, ...}: {
  home.packages = with pkgs; [
    qbittorrent
    telegram-desktop
    anydesk
    # bitwarden-desktop lives in ../programs/bitwarden.nix, with its autostart entry
  ];
}
