{pkgs, ...}: {
  home.packages = with pkgs; [
    libreoffice-qt
    hunspell
    hunspellDicts.uk_UA
    hunspellDicts.en_US
  ];
}
