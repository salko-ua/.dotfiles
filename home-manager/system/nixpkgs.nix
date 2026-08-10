{
  inputs,
  cudaSupport ? false,
  ...
}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
      inputs.self.overlays.additions
      inputs.self.overlays.modifications
      (
        if cudaSupport
        then inputs.self.overlays.unstable-packages-cuda
        else inputs.self.overlays.unstable-packages
      )
    ];
  };
}
