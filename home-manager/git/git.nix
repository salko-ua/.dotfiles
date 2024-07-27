{
  programs.git = {
    enable = true;
    userName = "salko-ua";
    userEmail = "chips69jamil69game@gmail.com";
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
