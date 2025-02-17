{
  pkgs,
  ...
}:
{
  programs.bun = {
    enable = true;
    package = pkgs.bun;
  };
}
