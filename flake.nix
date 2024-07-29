{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    # theme
    catppuccin.url = "github:catppuccin/nix";
    grub2-themes.url = "github:vinceliuice/grub2-themes";
  };
  outputs = inputs@ {
    self,
    nixpkgs,
    home-manager,
    catppuccin,
    grub2-themes,
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
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    overlays = import ./overlays {inherit inputs;};
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
	  catppuccin.nixosModules.catppuccin
	  grub2-themes.nixosModules.default
          # > Our main nixos configuration file <
          ./nixos/configuration.nix
        ];
      };
    };

    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      salo = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; 
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
	  catppuccin.homeManagerModules.catppuccin
	  # > Our main home-manager configuration file <
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
