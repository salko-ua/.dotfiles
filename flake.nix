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

    # A host = common config (./nixos, ./home-manager) + its dir in ./hosts.
    mkNixos = hostDir:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules =
          [
            catppuccin.nixosModules.catppuccin
            hostDir
          ]
          ++ autoImport ./nixos;
      };

    mkHome = hostDir:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules =
          [
            catppuccin.homeModules.catppuccin
            inputs.plasma-manager.homeModules.plasma-manager
            nix-index-database.homeModules.nix-index
            {
              home = {
                inherit username;
                homeDirectory = "/home/${username}";
              };
            }
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
      salo = mkNixos ./hosts/laptop;
      salo-pc = mkNixos ./hosts/desktop;
    };

    homeConfigurations = {
      # nh home switch tries "user@hostname" first, then falls back to "user"
      salo = mkHome ./hosts/laptop;
      "salo@salo-pc" = mkHome ./hosts/desktop;
    };
  };
}
