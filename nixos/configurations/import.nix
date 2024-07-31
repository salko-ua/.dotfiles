{
  imports = [
    # You can also split up your configuration and import pieces of it here:
    ./gui/gui.nix
    ./pkgs/pkgs.nix
    ./theme/theme.nix
    ./steam/steam.nix
    ./nvidia/nvidia.nix
    ./grub/grub.nix
    ./users/users.nix
    ./plasma/plasma.nix
  ];
}
