{ pkgs, ... }: 
{
  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = ["salo"];

  virtualisation.libvirtd.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;
}
