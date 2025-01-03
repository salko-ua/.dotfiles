{
  programs.git = {
    enable = true;
    userName = "salko-ua";
    userEmail = "github@salko-ua.de";
    #signing = {
    #  key = "313F67D1EAB770F9";
    #  signByDefault = true;
    #};
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      url = {
        "ssh://git@github.com/" = {
          insteadOf = ["https://github.com/"];
        };
      };
    };
  };
}
