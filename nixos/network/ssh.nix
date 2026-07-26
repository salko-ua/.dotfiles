{
  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = ["salo" "root"];
      PermitRootLogin = "yes";
    };
  };
}
