# Wipe-on-boot root. Imported manually (never via lib/auto-import.nix) because
# impermanence has no global "disable" switch and this module destroys data by
# design -- only salo-pc opts in.
#
# On-disk layout (btrfs top-level, subvolid=5):
#   root       -> /        wiped every boot, previous copy kept in old_roots/
#   persist    -> /persist survives, holds everything listed below
#   nix        -> /nix     survives
#   old_roots/ read-only snapshots of the last 30 days of roots
{
  inputs,
  pkgs,
  lib,
  config,
  utils,
  ...
}: let
  # The initrd wipe service runs before anything is mounted, so it needs the
  # raw device. Must match hosts/desktop/hardware-configuration.nix.
  btrfs-volume = "/dev/mapper/luks-7fbde2fd-f08a-430a-86cf-8b0940d13df5";
in {
  imports = [
    inputs.impermanence.nixosModules.impermanence
    # `my.persistence.directories` reads better at the call site than
    # `environment.persistence."/persist".directories`.
    (lib.modules.mkAliasOptionModule ["my" "persistence"] ["environment" "persistence" "/persist"])
  ];

  # The per-user list lives here, not in ./home-manager, because that tree is
  # also auto-imported into the laptop's *standalone* home-manager -- where
  # impermanence's home module refuses to load. impermanence's NixOS module
  # appends its own home-manager.nix to sharedModules for us.
  home-manager.sharedModules = [./home.nix];

  boot.initrd.systemd = {
    # wipe-file-systems below is a systemd-initrd unit and silently does
    # nothing under the legacy initrd. Default is already true on 26.05; pin it
    # so a future default flip cannot quietly stop wiping root.
    enable = true;

    initrdBin = with pkgs; [
      btrfs-progs
      coreutils
      util-linux
      findutils
    ];

    services.wipe-file-systems = {
      # Specify dependencies explicitly
      unitConfig.DefaultDependencies = false;
      serviceConfig = {
        # The script needs to run to completion before this service is done
        Type = "oneshot";
        # also print to TTY
        StandardOutput = "journal+console";
        StandardError = "journal+console";
      };
      # This service is required for boot to succeed
      requiredBy = ["initrd.target"];
      # Should complete before any file systems are mounted
      before = ["sysroot.mount"];

      # Wait for the disk to appear
      requires = ["${utils.escapeSystemdPath btrfs-volume}.device"];
      after = [
        "${utils.escapeSystemdPath btrfs-volume}.device"
        # Allow hibernation to resume before trying to alter any data
        "local-fs-pre.target"
      ];

      script = ''
        set -e
        MOUNTDIR=/mnt
        BTRFS_VOL=${btrfs-volume}

        echo "Mounting btrfs..."
        mkdir -p $MOUNTDIR
        mount -t btrfs -o subvol=/,user_subvol_rm_allowed $BTRFS_VOL $MOUNTDIR

        # Created up front so the find below cannot fail on a fresh disk.
        mkdir -p $MOUNTDIR/old_roots

        echo "Deleting old subvolumes"
        # -mindepth 1 so old_roots itself is never a deletion candidate.
        for old_subvolume in $(find $MOUNTDIR/old_roots/ -mindepth 1 -maxdepth 1 -mtime +30); do
          echo "Deleting $old_subvolume"
          btrfs property set "$old_subvolume" ro false
          btrfs subvolume delete -R "$old_subvolume"
        done

        if [[ -e $MOUNTDIR/root ]]; then
          echo "Moving existing root to the old_roots directory..."
          timestamp=$(date --date="@$(stat -c %Y $MOUNTDIR/root)" "+%Y-%m-%-d_%H:%M:%S")
          mv $MOUNTDIR/root "$MOUNTDIR/old_roots/$timestamp"
          btrfs property set "$MOUNTDIR/old_roots/$timestamp" ro true
        fi

        btrfs subvolume create $MOUNTDIR/root
        umount $MOUNTDIR
        echo "Done!"
      '';
    };
  };

  # Ensure that all files are properly chowned
  # https://github.com/Misterio77/nix-config/blob/61aa0ab5e26c528eb6be98dee1a8b9061003bf2e/hosts/common/global/optin-persistence.nix#L29-L38
  system.activationScripts.persistent-dirs.text = let
    mkHomePersist = user:
      lib.optionalString user.createHome ''
        mkdir -p /persist/${user.home}
        chown ${user.name}:${user.group} /persist/${user.home}
        chmod ${user.homeMode} /persist/${user.home}
      '';
    users = lib.attrValues config.users.users;
  in
    lib.concatLines (map mkHomePersist users);

  fileSystems."/persist".neededForBoot = true;

  environment.persistence."/persist" = {
    hideMounts = true;

    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos" # uid/gid allocations -- losing this reshuffles users
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"

      # Services this host actually runs (see ./nixos).
      "/var/lib/AccountsService"
      "/var/lib/cups"
      "/var/lib/docker"
      "/var/lib/flatpak"
      "/var/lib/fwupd"
      "/var/lib/libvirt"
      "/var/lib/sddm"
      "/var/lib/upower"
    ];

    files = [
      "/etc/machine-id"
      # The host key systemd derives encrypted credentials from. libvirtd uses
      # LoadCredentialEncrypted= for /var/lib/libvirt/secrets/secrets-encryption-key,
      # so if this key changes the persisted encrypted secret stops decrypting
      # and libvirtd fails with 243/CREDENTIALS on every boot.
      #
      # systemd demands mode exactly 0400 and refuses the key with EPERM
      # otherwise (creds-util.c: `(st.st_mode & 07777) != 0400`). The rule in
      # systemd.tmpfiles.settings below enforces that, because a hand-copied
      # key is the one way this file shows up with the wrong mode.
      "/var/lib/systemd/credential.secret"
      # Regenerated on boot otherwise, so every reboot would trip the clients'
      # known_hosts.
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  # Fix the mode rather than the copy: systemd rejects the credential host key
  # unless it is exactly 0400. Targets the /persist path so it does not depend
  # on the bind mount being up yet. "z" only adjusts an existing file, so this
  # is a no-op before the key has ever been created.
  systemd.tmpfiles.settings."10-impermanence-credential-secret" = {
    "/persist/var/lib/systemd/credential.secret".z = {
      mode = "0400";
      user = "root";
      group = "root";
    };
  };

  # /etc/sudoers.lecture-status lives on the wiped root, so sudo would lecture
  # on the first invocation after every single boot.
  security.sudo.extraConfig = ''
    Defaults        lecture=never
  '';
}
