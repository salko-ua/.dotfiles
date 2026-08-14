{pkgs, ...}: {
  programs.btop = {
    enable = true;
    package = pkgs.btop-rocm;
    settings = {
      vim_keys = true;
      base_10_sizes = true;
      swap_disk = false;
      disks_filter = "/ /boot";
    };
  };
}
