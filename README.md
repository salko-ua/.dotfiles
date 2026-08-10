# .dotfiles

NixOS + standalone home-manager, two hosts:

- `salo-laptop` — Legion 5 (intel/nvidia)
- `salo-pc` — desktop (amd/amd)

Common config lives in `nixos/` and `home-manager/` (everything there is
auto-imported), per-host stuff in `hosts/<host>/`.

## Fresh install

Install a blank NixOS however you like, then:

```sh
git clone git@github.com:salko-ua/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

The path matters — `nh` is pinned to `~/.dotfiles`.

**PC only:** the hardware config in the repo is a placeholder. Replace it
with the real one and stage it (flakes don't see untracked files):

```sh
sudo nixos-generate-config --show-hardware-config > hosts/desktop/hardware-configuration.nix
git add hosts/desktop/hardware-configuration.nix
```

The laptop's hardware config is already in the repo, skip this.

First switch (blank nix has flakes disabled, hence the env var):

```sh
sudo NIX_CONFIG="experimental-features = nix-command flakes" \
  nixos-rebuild switch --flake .#salo-pc   # or .#salo-laptop
```

Then home-manager:

```sh
nix run home-manager -- switch --flake .
```

Log out, log back in (or reboot). From now on it's just:

```sh
nh os switch .     # osupdate
nh home switch .   # nhupdate
```

