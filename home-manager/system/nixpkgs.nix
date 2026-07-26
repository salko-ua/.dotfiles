{inputs, ...}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
      inputs.self.overlays.additions
      inputs.self.overlays.modifications
      inputs.self.overlays.unstable-packages
    ];
  };
}
