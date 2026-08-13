# Per-user opt-in state for salo-pc. Pulled in via home-manager.sharedModules
# from ../impermanence, so it never reaches the laptop's standalone
# home-manager (where impermanence's home module refuses to load).
#
# Anything not listed here is gone after a reboot. Declaratively managed files
# (home.file, xdg.configFile, plasma-manager, programs.*) do not need listing --
# home-manager rewrites them on every activation.
{lib, ...}: {
  imports = [
    (lib.modules.mkAliasOptionModule ["my" "persistence"] ["home" "persistence" "/persist"])
  ];

  my.persistence = {
    directories = [
      # Documents and the like
      ".dotfiles"
      "dev"

      # Credentials -- losing these is the most annoying failure mode
      ".ssh"
      ".gnupg"
      ".pki"

      # Chat / media / games
      ".config/equibop"
      ".local/share/Steam"
      ".steam"
      ".local/share/PrismLauncher"
      ".local/share/TelegramDesktop"
      ".config/qBittorrent"
      ".local/share/qBittorrent"

      # Browsers -- programs.firefox sets configPath to .config/mozilla
      ".config/mozilla"
      ".mozilla"

      # Other apps
      ".config/Bitwarden"
      ".config/easyeffects"
      ".local/share/easyeffects"
      ".config/mozc"
      ".config/variety"
      ".zoom"

      # Dev tooling
      ".claude"
      ".config/gh"
      ".config/nvim"
      ".local/share/nvim"
      ".local/state/nvim"
      ".local/share/direnv"
      ".local/share/fish"
      ".local/state/nix"
      ".local/state/home-manager"

      # Plasma runtime state that is not worth re-teaching every boot
      ".local/share/baloo"
      ".local/share/dolphin"
      ".local/share/konsole"
      ".local/share/kactivitymanagerd"
      ".local/share/plasma-systemmonitor"
      ".local/share/sddm"
      ".local/share/Trash"
      ".local/state/wireplumber" # per-device volumes

      # Caches that are expensive, not cheap, to rebuild
      ".cache/nix"
      ".cache/nvim"
      ".cache/fish"
      ".cache/mesa_shader_cache"
      ".cache/fontconfig"
      ".cache/thumbnails"
      ".cache/mozilla"
      ".cache/com.bitwarden.desktop"
    ];

    files = [
      ".claude.json"
      ".bash_history"
      ".pulse-cookie"
    ];
  };
}
