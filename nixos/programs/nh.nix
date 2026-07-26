{pkgs, ...}: {
  environment.sessionVariables.NH_FLAKE = "/home/salo/.dotfiles";
  environment.systemPackages = [pkgs.nh];
}
