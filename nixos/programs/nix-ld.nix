{
  pkgs,
  options,
  ...
}: {
  programs.nix-ld = {
    enable = true;
    libraries =
      options.programs.nix-ld.libraries.default
      ++ (with pkgs; [
        e2fsprogs
        gcc
        libgcc
        unixodbc
        unixodbcDrivers.msodbcsql17
        openssl
        openssl_1_1
      ]);
  };
}
