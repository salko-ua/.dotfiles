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
      position.x = 480;
      position.y = 245;
      padding.x = 15;
      padding.y = 15;
    };

    mouse.hide_when_typing = false;
  };
}
