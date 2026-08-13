{
  users.users.salo = {
    hashedPassword = "$y$j9T$HlMj/BCljFGX8MfbgdvAL1$pBRwCmhw0qhrhq8/Iw1N069Qzwd87ZZah5ZTxW5yyO7";
    isNormalUser = true;
    # Both hosts' keys, so ssh/scp/sftp works in either direction between them
    # (this file is shared, so each host authorizes the other and itself).
    openssh.authorizedKeys.keys = [
      # salo-laptop
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOZfIIW2IMUMHb4stmtyxZeBTtk6jjrl62GpP5Gkvjsf"
      # salo-pc
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOx/bOBxbuqXjF9PycNtinO0ex57mQPpY8cq+KQ/8xWn github@salko-ua.de"
    ];
    extraGroups = ["wheel" "docker" "libvirtd" "networkmanager"];
  };
}
