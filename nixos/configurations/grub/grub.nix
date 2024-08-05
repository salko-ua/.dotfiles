{
  pkgs,
  lib,
  ...
}: {
  boot.loader.grub = let
    font-path = "${pkgs.spleen}/share/fonts/misc/spleen-16x32.otf";
  in {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    extraConfig = ''
      GRUB_CMDLINE_LINUX_DEFAULT="nvidia-drm.modeset=1"
    '';

    theme = lib.mkForce (let
      theme-path = "src/catppuccin-mocha-grub-theme";
    in
      pkgs.stdenv.mkDerivation rec {
        pname = "catppuccin-mocha-grub";
        version = "1.0.0";
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "grub";
          rev = "v${version}";
          hash = "sha256-/bSolCta8GCZ4lP0u5NVqYQ9Y3ZooYCNdTwORNvR7M0=";
        };
        nativeBuildInputs = with pkgs; [
          grub2
          spleen
        ];
        # HACK: using find 'n replace to change the font and to use relative
        # sizes for the menu options (the original didn't scale to 4k very well)
        prePatch = ''
          substituteInPlace ${theme-path}/theme.txt \
          --replace "Unifont Regular 16" "Spleen 16x32 Regular 32" \
          --replace "left = 50%-240" "left = 20%" \
          --replace "width = 480" "width = 60%"
        '';
        buildPhase = ''
          grub-mkfont --size 32 ${font-path} -o ${theme-path}/font.pf2
        '';
        installPhase = ''
          cp -r ${theme-path} $out
        '';
      });
  };
  boot.loader.efi.canTouchEfiVariables = true;
}