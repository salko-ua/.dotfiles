{
  programs.steam = {
    enable = true;
    package = {
      pkgs.steam-small.override {
        extraEnv = {
          MANGOHUD = true;
          OBS_VKCAPTURE = true;
          RADV_TEX_ANISO = 16;
        };
        
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      package = {
        pkgs.steam-small.override.extraEnv.MANGOHUD = true;
      };
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };

    programs.gamemode.enable = true;

    environment.variables = {
      FONTCONFIG_PATH = "/etc/fonts";
    };
  };
}
