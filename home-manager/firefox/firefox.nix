{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ ./ublock-origin.nix ];

  programs.firefox = {
    enable = true;
    profiles = {
      salo = {
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          bitwarden
          ublock-origin
          sponsorblock
          limit-limit-distracting-sites
          grammarly
          languagetool
          disable-javascript
          enhancer-for-youtube
          simple-tab-groups   
        ];

        settings = {
          "browser.sessionstore.max_resumed_crashes" = -1;
        };
      };
      stuff = {
        id = 1;
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          bitwarden
          ublock-origin
        ];
      };
    };
  };

}
