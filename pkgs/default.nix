# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  actual-server = pkgs.callPackage ./actual-server {};
  actual-client = pkgs.callPackage ./actual-client {};
}
