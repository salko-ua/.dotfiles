{pkgs, ...}: {
  programs.fish = {
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
      upd = "nh os switch & nh home switch";
      dps = "docker ps --format \"table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}\"";
    };
  };
}
