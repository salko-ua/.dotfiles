{pkgs, ...}: {
  # Generations manager
  environment.systemPackages = [pkgs.home-manager];
}
