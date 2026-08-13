{pkgs, ...}: {
  # Puts the other host's home in Dolphin's Places, over the ssh both machines
  # already run (see nixos/network/{ssh,avahi}.nix for the .local names).
  # Runs on every login because on salo-pc this file is wiped with the root --
  # see the script's docstring for why it is not persisted instead.
  my.setup-stuff.dolphin-places.command = "${pkgs.python3}/bin/python3 ${./add-places.py}";
}
