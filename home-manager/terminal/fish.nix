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
      update = "sudo nixos-rebuild switch --flake . && home-manager switch --flake .";
    };
  };
}
