{pkgs, ...}: {
  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs:
        with pkgs; [
          mangohud
          gamemode
        ];
    };
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [proton-ge-bin];
  };

  programs.gamemode.enable = true;
  environment.variables = {
    FONTCONFIG_PATH = "/etc/fonts";
  };
}
