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
      nhupdate = "nh home switch .";
      dps = "docker ps --format \"table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}\"";
    };
  };

  # tide only writes its config through its own wizard, into fish universal
  # variables (~/.config/fish/fish_variables) -- which is not persisted, so on
  # salo-pc the prompt would fall back to unconfigured after every boot.
  # --auto answers every prompt from the flags and skips the tty size check.
  my.setup-stuff.fish-prompt.command = ''
    ${pkgs.fish}/bin/fish -c 'tide configure --auto --style=Lean --prompt_colors="True color" --show_time=No --lean_prompt_height="One line" --prompt_spacing=Compact --icons="Few icons" --transient=No'
  '';
}
