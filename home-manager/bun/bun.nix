{
  pkgs,
  ...
}:
{
  programs.bun = {
    enable = true;
    package = pkgs.unstable.bun;
  };
}
