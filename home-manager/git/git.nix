{
  programs.git = {
    enable = true;
    #signing = {
    #  key = "313F67D1EAB770F9";
    #  signByDefault = true;
    #};
    settings = {
      user.name = "salko-ua";
      user.email = "github@salko-ua.de";
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
