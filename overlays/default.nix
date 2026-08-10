# This file defines overlays
{inputs, ...}: let
  mkUnstable = cudaSupport: final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
      config.cudaSupport = cudaSupport;
    };
  };
in {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'.
  # Two variants: hosts pick one via the cudaSupport flag in flake.nix
  # (laptop = nvidia/cuda, desktop = amd, no use for CUDA closures).
  unstable-packages = mkUnstable false;
  unstable-packages-cuda = mkUnstable true;
}
