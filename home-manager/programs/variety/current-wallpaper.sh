#!/usr/bin/env bash
# Keep ~/.config/variety/current-wallpaper pointing at whatever variety last set.
#
# Why: plasma stores the desktop wallpaper in
# ~/.config/plasma-org.kde.plasma.desktop-appletsrc, which is NOT persisted, so
# every boot starts with plasma's stock wallpaper until variety gets around to
# changing it -- that is the flash of default wallpaper at login.
#
# plasma-manager cannot point at "the current wallpaper" directly because the
# filename changes constantly, so it points at this stable symlink instead
# (programs.plasma.workspace.wallpaper). The symlink lives under .config/variety
# which IS persisted, so at boot it already resolves to the last image used and
# plasma comes up on it directly.
#
# variety records the current file's path in wallpaper.jpg.txt on every change,
# which is what the accompanying .path unit watches.
set -uo pipefail

record="$HOME/.config/variety/wallpaper/wallpaper.jpg.txt"
link="$HOME/.config/variety/current-wallpaper"

[[ -r $record ]] || exit 0

target="$(head -n1 "$record")"
[[ -n $target && -r $target ]] || exit 0

# -n so an existing symlink is replaced rather than followed into its target dir.
ln -sfn "$target" "$link"
