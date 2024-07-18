{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager }: 
    let
      nix_lib = nixpkgs.lib;
      home_lib = home-manager.lib;
      system = "x86_64-linux";	
      pkgs = nixpkgs.legacyPackages.${system};
    in  {
    nixosConfigurations = {
      nixos = nix_lib.nixosSystem {
	inherit system;
	modules = [ ./configuration.nix ];	
      };
    };
    homeConfigurations = {
      salo = home_lib.homeManagerConfiguration {
	inherit pkgs;
        modules = [ ./home.nix ];
      };
    };
  };
}
