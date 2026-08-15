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

# Skip wallpapers that are mostly white background. variety has no such filter --
# see white-fraction.py for why its lightness option is not one -- so the check
# happens here, after the fact: variety has already put the image on screen, so a
# rejected one is visible for the moment it takes to ask for the next.
#
# The counter stops a runaway: if the prepared buffer happens to be all-white,
# each skip triggers another change and another skip. After MAX_SKIPS in a row we
# keep whatever we are given rather than cycling the whole library. It lives in
# XDG_RUNTIME_DIR so it resets itself every boot.
skips="${XDG_RUNTIME_DIR:-/tmp}/variety-white-skips"
MAX_SKIPS=5

if [[ -n ${WHITE_FRACTION_SCRIPT:-} ]]; then
  white="$(python3 "$WHITE_FRACTION_SCRIPT" "$target")"
  count=$(cat "$skips" 2>/dev/null || echo 0)

  # bash cannot compare fractions, and rounding is fine at this granularity.
  if ((${white%.*} >= ${WHITE_FRACTION_MAX:-60})) && ((count < MAX_SKIPS)); then
    echo "$((count + 1))" >"$skips"
    echo "skipping ${target##*/}: ${white}% white background" >&2
    variety --profile "$HOME/.config/variety/" --next
    exit 0
  fi

  echo 0 >"$skips"
fi

# -n so an existing symlink is replaced rather than followed into its target dir.
ln -sfn "$target" "$link"
