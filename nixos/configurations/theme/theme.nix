{
  # grub
  boot.loader.grub.catppuccin.enable = true;
  boot.loader.grub.catppuccin.flavor = "mocha";
  boot.plymouth.catppuccin.enable = false;
  boot.plymouth.catppuccin.flavor = "mocha";
  

  # lock screen
  services.displayManager.sddm.catppuccin.enable = true;
  services.displayManager.sddm.catppuccin.background = ./home_night.png;
  services.displayManager.sddm.catppuccin.flavor = "mocha";
  services.displayManager.sddm.catppuccin.fontSize = "14";
  services.displayManager.sddm.catppuccin.loginBackground = false;
  catppuccin.enable = true;
  catppuccin.flavor = "mocha";
}
