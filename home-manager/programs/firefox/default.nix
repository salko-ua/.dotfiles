{
  inputs,
  pkgs,
  ...
}: let
  # Finally puts the `nur` flake input to use -- rycee packages Firefox addons
  # as XPIs in the store, so extensions are pinned instead of being fetched from
  # AMO on first run.
  addons = inputs.nur.legacyPackages.${pkgs.stdenv.hostPlatform.system}.repos.rycee.firefox-addons;
in {
  imports = [./ublock-origin.nix];

  programs.firefox = {
    enable = true;
    configPath = ".config/mozilla/firefox";

    profiles.default = {
      extensions = {
        force = true;

        # These are symlinked into <profile>/extensions individually
        # (home.file with recursive = true), so addons that are NOT packaged in
        # NUR survive alongside them. Three currently live only in the profile
        # and stay imperative -- nothing in NUR's 627 addons matches them:
        #   browsec@browsec.com                     Browsec VPN
        #   prathercc@gmail.com                     Discrub
        #   {099df96d-2b40-405a-a045-e3d7259cc419}  Rei Ayanami theme
        packages = with addons; [
          ublock-origin # configured in ./ublock-origin.nix
          darkreader
          bitwarden
          asbplayer
          youtube-shorts-block
        ];
      };

      # Only genuine preferences belong here. Firefox's prefs.js is ~95% its own
      # runtime churn (engagement counters, storageVersion/migration flags,
      # timestamps); pinning those would fight Firefox's own migrations, so they
      # are deliberately left to prefs.js.
      settings = {
        # Bitwarden handles credentials, so Firefox should not.
        "signon.rememberSignons" = false;
        "signon.management.page.breach-alerts.enabled" = false;
        "privacy.clearOnShutdown_v2.formdata" = true;

        # No speculative connections.
        "network.dns.disablePrefetch" = true;
        "network.prefetch-next" = false;
        "network.http.speculative-parallel-limit" = 0;

        # UI
        "browser.theme.toolbar-theme" = 0; # dark
        "findbar.highlightAll" = true;
        "accessibility.typeaheadfind.flashBar" = 0;
        "sidebar.visibility" = "hide-sidebar";
        "browser.ml.linkPreview.collapsed" = true;
        "extensions.pictureinpicture.enable_picture_in_picture_overrides" = true;
      };
    };
  };
}
