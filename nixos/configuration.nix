{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: 
let fallout = pkgs.fetchFromGitHub
  {
    owner = "shvchk";
    repo = "fallout-grub-theme";
    rev = "80734103d0b48d724f0928e8082b6755bd3b2078";
    sha256 = "sha256-7kvLfD6Nz4cEMrmCA9yq4enyqVyqiTkVZV5y4RyUatU=";
  };
in
{
  imports = [
    # modules/nixos import
    # outputs.nixosModules.moduleName

    # You can also split up your configuration and import pieces of it here:
    ./configurations/gui/gui.nix
    ./configurations/hyprland/hyprland.nix
    ./configurations/theme/theme.nix
    ./configurations/steam/steam.nix
    ./configurations/nvidia/nvidia.nix
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub2-theme = {
    enable = true;
    theme = "tela";
    footer = true;
  };
  

  fonts = {
    packages = with pkgs; [
      meslo-lgs-nf
      fantasque-sans-mono
    ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Kyiv";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "uk_UA.UTF-8";
    LC_IDENTIFICATION = "uk_UA.UTF-8";
    LC_MEASUREMENT = "uk_UA.UTF-8";
    LC_MONETARY = "uk_UA.UTF-8";
    LC_NAME = "uk_UA.UTF-8";
    LC_NUMERIC = "uk_UA.UTF-8";
    LC_PAPER = "uk_UA.UTF-8";
    LC_TELEPHONE = "uk_UA.UTF-8";
    LC_TIME = "uk_UA.UTF-8";
  };


  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
      nix-path = config.nix.nixPath;
    };
    channel.enable = false;

    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  networking.hostName = "nixos";

  users.users = {
    salo = {
      initialPassword = "sa lo";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOZfIIW2IMUMHb4stmtyxZeBTtk6jjrl62GpP5Gkvjsf"
      ];
      extraGroups = ["wheel"];
    };
  };
  
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
    };
  };

  system.stateVersion = "24.05";
}
