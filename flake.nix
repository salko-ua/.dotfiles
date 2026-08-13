{
  description = "hix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";

    # Opt-in state. Only salo-pc imports it (manual-modules/impermanence).
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # theme
    catppuccin.url = "github:catppuccin/nix/release-26.05";
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    plasma-manager,
    catppuccin,
    nix-index-database,
    ...
  }: let
    inherit (self) outputs;
    # Supported systems for your flake packages, shell, etc.
    username = "salo";
    autoImport = import ./lib/auto-import.nix;
    systems = ["x86_64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs systems;

    # Third-party home-manager modules, shared by both evaluation modes below.
    homeExtraModules = [
      catppuccin.homeModules.catppuccin
      inputs.plasma-manager.homeModules.plasma-manager
      nix-index-database.homeModules.nix-index
    ];

    homeUserConfig = {
      home = {
        inherit username;
        homeDirectory = "/home/${username}";
      };
    };

    # A host = common config (./nixos, ./home-manager) + its dir in ./hosts.
    # cudaSupport picks the pkgs.unstable overlay variant (see overlays/).
    #
    # homeAsNixosModule folds home-manager into the system closure instead of
    # exposing it as a standalone homeConfigurations entry. Impermanence forces
    # this: its home-manager.nix only declares `home.persistence` options and
    # asserts on manual import -- every bind mount is created by its NixOS
    # module, which reads config.home-manager.users.*. Standalone home-manager
    # therefore cannot persist anything.
    mkNixos = {
      hostDir,
      cudaSupport ? false,
      homeAsNixosModule ? false,
    }:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs cudaSupport;};
        modules =
          [
            catppuccin.nixosModules.catppuccin
            hostDir
          ]
          ++ autoImport ./nixos
          ++ nixpkgs.lib.optionals homeAsNixosModule [
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                # useGlobalPkgs stays off on purpose: home-manager then
                # re-imports nixpkgs from pkgs.path through its own
                # nixpkgs.{config,overlays}, so home-manager/system/nixpkgs.nix
                # keeps working byte-for-byte as it does standalone.
                useUserPackages = true;
                # First activation lands on a home dir full of unmanaged files.
                backupFileExtension = "hm-bak";
                extraSpecialArgs = {inherit inputs outputs cudaSupport;};
                sharedModules = homeExtraModules;
                users.${username} = {
                  imports =
                    autoImport ./home-manager
                    ++ [
                      homeUserConfig
                      (hostDir + /home.nix)
                    ];
                };
              };
            }
          ];
      };

    mkHome = {
      hostDir,
      cudaSupport ? false,
    }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs cudaSupport;};
        modules =
          homeExtraModules
          ++ [
            homeUserConfig
            (hostDir + /home.nix)
          ]
          ++ autoImport ./home-manager;
      };
  in {
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = {
      # attr key == networking.hostName (nh os switch resolves by hostname)
      salo-laptop = mkNixos {
        hostDir = ./hosts/laptop;
        cudaSupport = true; # nvidia
      };
      salo-pc = mkNixos {
        hostDir = ./hosts/desktop;
        homeAsNixosModule = true; # impermanence -- see mkNixos
      };
    };

    # salo-pc is deliberately absent: its home-manager generation is built by
    # `nh os switch`. There is no "salo" fallback either, so `nh home switch`
    # on the desktop fails loudly instead of silently resolving to the laptop's
    # config (nh tries "user@hostname", then "user").
    homeConfigurations = {
      "salo@salo-laptop" = mkHome {
        hostDir = ./hosts/laptop;
        cudaSupport = true; # nvidia
      };
    };
  };
}
