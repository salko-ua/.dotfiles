{pkgs, ...}: {
  programs.claude-code.enable = true;
  # claude code expects this file at a fixed path (see ~/.claude/settings.json);
  # the file may already exist unmanaged, so activation must overwrite it
  home.file.".claude/statusline.sh" = {
    source = pkgs.replaceVars ./statusline.sh {
      jq = "${pkgs.jq}/bin/jq";
    };
    executable = true;
    force = true;
  };
}
