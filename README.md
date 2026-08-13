# .dotfiles

NixOS + home-manager, two hosts:

- `salo-laptop` — Legion 5 (intel/nvidia), standalone home-manager
- `salo-pc` — desktop (amd/amd), **impermanence**, home-manager as a NixOS module

Common config lives in `nixos/` and `home-manager/` (everything there is
auto-imported), per-host stuff in `hosts/<host>/`. `manual-modules/` is *not*
auto-imported — see its README.

Because `salo-pc` builds home-manager as part of the system closure, its home
generation comes from `nh os switch`; `nh home switch` only applies to the
laptop.

| | `salo-laptop` | `salo-pc` |
|---|---|---|
| `nh os switch .` | system | system **+ home** |
| `nh home switch .` | home | fails on purpose |

## Fresh install

Install a blank NixOS however you like, then:

```sh
git clone git@github.com:salko-ua/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

The path matters — `nh` is pinned to `~/.dotfiles`.

Both hosts' hardware configs are already in the repo. Don't regenerate the
PC's — `hosts/desktop/hardware-configuration.nix` is hand-edited for
impermanence (`subvol=root` + `/persist`) and `nixos-generate-config` would
throw that away. On genuinely new hardware, generate it, then re-apply the
`fileSystems` block by hand and stage it (flakes don't see untracked files).

First switch (blank nix has flakes disabled, hence the env var):

```sh
sudo NIX_CONFIG="experimental-features = nix-command flakes" \
  nixos-rebuild switch --flake .#salo-pc   # or .#salo-laptop
```

Then home-manager — **laptop only**, the PC already got it from the switch above:

```sh
nix run home-manager -- switch --flake .
```

Log out, log back in (or reboot). From now on it's just:

```sh
nh os switch .     # osupdate
nh home switch .   # nhupdate — laptop only
```

## Impermanence (`salo-pc` only)

`/` is a btrfs subvolume that is **deleted and recreated on every boot** by an
initrd service (`manual-modules/impermanence`). Only what is listed in
`manual-modules/impermanence/default.nix` (system) and `home.nix` (user)
survives, bind-mounted back out of `/persist`.

```
btrfs top-level (subvolid=5)
├── root       -> /         wiped every boot
├── persist    -> /persist  the opt-in state
├── nix        -> /nix
└── old_roots/ read-only copies of the last 30 days of roots
```

Anything home-manager writes declaratively (`home.file`, `xdg.configFile`,
`programs.*`, plasma-manager) does **not** need listing — it is rewritten on
every activation. Everything else does. To keep a new path, add it and switch:

```sh
# system state
my.persistence.directories = [ "/var/lib/foo" ];
# user state, in manual-modules/impermanence/home.nix
my.persistence.directories = [ ".config/foo" ];
```

Some tools only write their config through their own CLI, so there is nothing to
persist *or* to declare. `my.setup-stuff.<name>.command`
(`home-manager/system/setup-stuff.nix`) runs such a command as a systemd user
service on every login — currently just `tide configure` for the fish prompt.
Commands there must be idempotent.

Lost something after a reboot? It is still in `/mnt/btr_pool/old_roots/` for 30
days:

```sh
sudo mount --mkdir -o subvolid=5 /dev/mapper/luks-* /mnt/btr_pool
ls /mnt/btr_pool/old_roots/
```

### Migrating an existing install onto it

`/` must move from the btrfs top-level to a `root` subvolume, and `/persist`
must exist and be seeded. `manual-modules/impermanence/migrate.sh` does that;
it only ever *adds* data, so the old top-level root and the old `home`
subvolume stay put as a rollback path.

```sh
nixos-rebuild build --flake .#salo-pc            # produces ./result
sudo ./manual-modules/impermanence/migrate.sh --dry-run
sudo ./manual-modules/impermanence/migrate.sh
sudo nixos-rebuild boot --flake .#salo-pc        # boot, NOT switch
reboot
```

If the reboot goes wrong, pick the previous generation in GRUB — it mounts the
old top-level `/` and the old `home` subvolume, unchanged.

Once you are happy, reclaim the space the old layout still occupies:

```sh
sudo mount --mkdir -o subvolid=5 /dev/mapper/luks-* /mnt/btr_pool
sudo btrfs subvolume delete /mnt/btr_pool/home     # old /home subvolume
cd /mnt/btr_pool && sudo rm -rf etc var root srv usr tmp bin lib64  # old top-level root
```

