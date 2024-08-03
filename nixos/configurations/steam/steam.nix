{ pkgs, ... }: 
{
  steam = pkgs.steam.overrideAttrs = (e: rec {
    # Add arguments to the .desktop entry
    desktopItem = e.desktopItem.override (d: {
      exec = "${d.exec} -forcedesktopscaling 1.5 %u";
    });

    # Update the install script to use the new .desktop entry
    installPhase = builtins.replaceStrings [ "${e.desktopItem}" ] [ "${desktopItem}" ] e.installPhase;
  });
  

  hardware.graphics = {
    extraPackages = with pkgs; [mangohud];
    extraPackages32 = with pkgs; [mangohud];
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
