{pkgs, ...}: {
  programs.alacritty.settings = {
    terminal.shell.program = "${pkgs.fish}/bin/fish";
    window = {
      dimensions = {
        columns = 80;
        lines = 24;
      };
      opacity = 0.50;
      blur = true;
      decorations_theme_variant = "dark";
      decorations = "Full";
      padding.x = 10;
      padding.y = 10;
    };
    font = {
      size = 16;
    };

    mouse.hide_when_typing = false;
  };
}
