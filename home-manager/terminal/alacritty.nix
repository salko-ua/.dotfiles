{pkgs, ...}: {
  programs.alacritty.settings = {
    terminal.shell.program = "${pkgs.fish}/bin/fish";
    window = {
      dimensions = {
        columns = 80;
        lines = 24;
      };
      opacity = 0.85;
      blur = true;
      decorations_theme_variant = "dark";
      startup_mode = "Fullscreen";
      decorations = "None";
    };
    font = {
      size = 18;
    };

    mouse.hide_when_typing = false;
  };
}
