{
  description = "hix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    # theme
    catppuccin.url = "github:catppuccin/nix";
  };
  outputs = inputs@ {
    self,
    nixpkgs,
    home-manager,
    catppuccin,
    ...
  }: 
  let
    inherit (self) outputs;
    # Supported systems for your flake packages, shell, etc.
    username = "salo";
    systems = ["x86_64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in 
  {
    #packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
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
	        catppuccin.homeManagerModules.catppuccin
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
