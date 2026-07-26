{pkgs, ...}: {
  environment.etc."dict.conf".text = "server dict.org";
  environment.systemPackages = [pkgs.dict];
}
