{pkgs, ...}: {
  programs.fish = {
    interactiveShellInit = ''
      set fish_greeting FUCKING FISH $version
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
