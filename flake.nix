{
  description = "hix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
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
    catppuccin.url = "github:catppuccin/nix";
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
    systems = ["x86_64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    #packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = {
      salo = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          catppuccin.nixosModules.catppuccin
          ./nixos/configuration.nix
        ];
      };
    };

    homeConfigurations = {
      salo = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          catppuccin.homeModules.catppuccin
          inputs.plasma-manager.homeManagerModules.plasma-manager
          nix-index-database.hmModules.nix-index
          ./home-manager/home.nix
          {
            home = {
              inherit username;
              homeDirectory = "/home/${username}";
            };
          }
        ];
      };
    };
  };
}
