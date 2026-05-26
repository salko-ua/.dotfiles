{ pkgs, options, ... }:
{
  programs.nix-ld = {
    enable = true;
    libraries =
      options.programs.nix-ld.libraries.default
      ++ (with pkgs; [
        e2fsprogs
        gcc
        libgcc
        unixODBC
        unixODBCDrivers.msodbcsql17
        openssl
        openssl_1_1
      ]);
  };

  environment.unixODBCDrivers = [ pkgs.unixODBCDrivers.msodbcsql17 ];
  
  environment.etc."openssl.cnf".text = ''
    openssl_conf = openssl_init

    [openssl_init]
    ssl_conf = ssl_sect

    [ssl_sect]
    system_default = system_default_sect

    [system_default_sect]
    MinProtocol = TLSv1
    CipherString = DEFAULT@SECLEVEL=1
  '';

  environment.variables.OPENSSL_CONF = "/etc/openssl.cnf";

  #environment.etc."odbcinst.ini".text = ''
  #  [ODBC Driver 17 for SQL Server]
  #  Description=Microsoft ODBC Driver 17 for SQL Server
  #  Driver=${pkgs.unixODBCDrivers.msodbcsql17}/lib/libmsodbcsql-17.7.so.1.1
  #'';
}
