{ pkgs, ...}:
{
  programs.alacritty.settings = {
    shell.program = "${pkgs.fish}/bin/fish";
    window = { 
      dimensions = {
        columns = 80;
        lines = 24;
      };
      opacity = 0.85;
      blur = true;
      decorations_theme_variant = "dark";
      position.x = 1280;
      position.y = 720;
      padding.x = 15;
      padding.y = 15;
    };

    mouse.hide_when_typing = true;
  };
}
