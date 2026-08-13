# Dolphin's Places lists the system disk twice, both entries named "root" and
# both pointing at /. udisks2 exposes the LUKS *container* partition and its
# unlocked cleartext mapper as two separate volumes, and since the mapper is
# what carries the btrfs label, both inherit the same name and mount point:
#
#   /org/freedesktop/UDisks2/block_devices/dm_2d0       filePath=/  label=root
#   /org/freedesktop/UDisks2/block_devices/nvme0n1p2    filePath=/  label=root
#
# Hide the container -- the mapper is the one worth showing. UDISKS_IGNORE is
# udisks2's own mechanism (see its 80-udisks2.rules).
#
# The UUIDs come from boot.initrd.luks.devices rather than being hardcoded, so
# this is a no-op on hosts without full-disk encryption (salo-laptop has none)
# and never drifts from hardware-configuration.nix.
{
  config,
  lib,
  ...
}: let
  luksUuids = lib.pipe config.boot.initrd.luks.devices [
    lib.attrValues
    (map (d: builtins.match "/dev/disk/by-uuid/(.+)" d.device))
    (lib.filter (m: m != null))
    (map lib.head)
  ];
in {
  # Scoped to the specific container UUIDs on purpose: a blanket
  # ID_FS_TYPE=="crypto_LUKS" rule would also stop Dolphin from offering to
  # unlock encrypted USB drives.
  services.udev.extraRules =
    lib.concatMapStrings (uuid: ''
      SUBSYSTEM=="block", ENV{ID_FS_UUID}=="${uuid}", ENV{UDISKS_IGNORE}="1"
    '')
    luksUuids;
}
