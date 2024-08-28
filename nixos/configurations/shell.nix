{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  # nativeBuildInputs is usually what you want -- tools you need to run
  nativeBuildInputs =
    with pkgs;
    with python312Packages;
    [
      python312
      numpy
      rembg
    ];
}
