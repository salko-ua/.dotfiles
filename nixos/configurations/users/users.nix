{ pkgs, ... }:
{
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  networking.hostName = "nixos";

  users.users = {
    salo = {
      initialPassword = "sa lo";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOZfIIW2IMUMHb4stmtyxZeBTtk6jjrl62GpP5Gkvjsf"
      ];
      extraGroups = ["wheel"];
    };
  };
}
