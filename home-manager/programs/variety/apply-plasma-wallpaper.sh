#!/usr/bin/env bash
# Point plasma's desktop wallpaper at the current-wallpaper symlink, at login.
#
# Why this exists even though plasma-manager already sets workspace.wallpaper:
# plasma-manager applies the wallpaper by handing a script to a *running*
# plasmashell over D-Bus, from an XDG autostart entry. On this machine that entry
# fires ~0.5s after plasmashell starts, while desktops() still returns an empty
# list -- so the loop inside it iterates over nothing. It cannot notice: the
# generated script guards with `trap 'success=0' ERR`, a bashism that never fires
# under the /bin/sh it runs as, so the "already applied" stamp gets written
# regardless and it will not retry for the rest of the session. Plasma then sits
# on its stock image until variety's first change -- which used to be 10s and is
# now 120s, so the flash became a two-minute wait.
#
# Waiting for a non-empty desktops() is necessary but NOT sufficient, which is
# what the first version of this got wrong. A containment exists before it has
# finished loading, and when it finishes it applies its own stored config -- which
# on this machine is an appletsrc that the wipe-on-boot root just deleted, so the
# write lands and is then clobbered back to plasma's default. It only shows up on
# a cold boot; restarting plasmashell by hand initialises fast enough to hide it.
#
# So: write, read back, and write again until the value sticks. evaluateScript
# hands back what the script print()ed, not its last expression, so both the
# count and the read-back have to be printed explicitly.
set -uo pipefail

link="$HOME/.config/variety/current-wallpaper"

# Dangling symlink: plasma would fall back to its default anyway, and variety
# will set a real one shortly.
[[ -e $link ]] || exit 0

url="file://$link"

# How long to keep watching, and how many consecutive agreeing reads mean the
# containment has settled rather than merely not having clobbered us yet.
DEADLINE=40
CONFIRMATIONS=3

apply='
let count = 0;
for (const desktop of desktops()) {
    desktop.wallpaperPlugin = "org.kde.image";
    desktop.currentConfigGroup = ["Wallpaper", "org.kde.image", "General"];
    desktop.writeConfig("Image", "'"$url"'");
    count += 1;
}
print(count);
'

read_back='
let image = "";
for (const desktop of desktops()) {
    desktop.currentConfigGroup = ["Wallpaper", "org.kde.image", "General"];
    image = desktop.readConfig("Image");
    break;
}
print(image);
'

plasma() {
  qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$1" 2>/dev/null
}

agreed=0
for ((i = 0; i < DEADLINE; i++)); do
  current="$(plasma "$read_back")"

  # variety copies each wallpaper to a uniquely named file under ~/Pictures (its
  # way around plasma caching by path) and sets that. Once it has, the session is
  # its business and we stop touching the wallpaper.
  if [[ $current == *variety-copied-wallpaper* ]]; then
    exit 0
  fi

  if [[ $current == "$url" ]]; then
    ((agreed++))
    ((agreed >= CONFIRMATIONS)) && exit 0
  else
    agreed=0
    plasma "$apply" >/dev/null
  fi

  sleep 1
done

echo "wallpaper did not stick after ${DEADLINE}s (plasma reports: ${current:-nothing})" >&2
exit 1
