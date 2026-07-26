{
  users.users.salo = {
    hashedPassword = "$y$j9T$HlMj/BCljFGX8MfbgdvAL1$pBRwCmhw0qhrhq8/Iw1N069Qzwd87ZZah5ZTxW5yyO7";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOZfIIW2IMUMHb4stmtyxZeBTtk6jjrl62GpP5Gkvjsf"
    ];
    extraGroups = ["wheel" "docker" "libvirtd" "networkmanager"];
  };
}
