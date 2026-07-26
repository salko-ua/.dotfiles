{pkgs, ...}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting "VERSION $version"
    '';
    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }
    ];
    shellAliases = {
      osupdate = "nh os switch .";
      nhupdate = "nh home swithc .";
      dps = "docker ps --format \"table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}\"";
    };
  };
}
