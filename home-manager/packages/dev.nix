{pkgs, ...}: {
  home.packages = with pkgs; [
    # poetry
    uv
    python3
    nodejs_22

    ruff
    basedpyright

    gnumake
    gcc
    git
    lazygit
    cloc

    mycli
    neovim
    vimPlugins.nvim-dbee
  ];
}
