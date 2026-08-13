#!/usr/bin/env python3
"""Idempotently add the other host's sftp share to Dolphin's Places panel.

Dolphin owns ~/.local/share/user-places.xbel: it saves through QSaveFile
(write-temp-then-rename), so the file cannot be an impermanence bind mount --
rename() over a mount point fails with EBUSY and Places would silently stop
saving. It also recreates the standard Home/Documents/... entries itself, so
managing the whole file declaratively would drop them.

Hence this: on salo-pc the file lives on the wiped root, so the entries are
re-added on every login by the setup-dolphin-places user service. Dolphin
watches the file with KDirWatch and reloads it, so the panel updates live.

Entries are inserted as text rather than via ElementTree, which would rewrite
the xmlns:bookmark/kdepriv/mime prefixes the rest of the file relies on.
"""

import os
import socket
import sys
import time

# The ID prefix is deliberately far in the future so it cannot collide with the
# <timestamp>/<n> IDs KDE hands out to the entries it creates itself.
PLACES = [
    ("salo-pc", "sftp://salo@salo-pc.local/home/salo"),
    ("salo-laptop", "sftp://salo@salo-laptop.local/home/salo"),
]

PATH = os.path.expanduser("~/.local/share/user-places.xbel")


def entry(host: str, href: str, uid: int) -> str:
    return (
        f' <bookmark href="{href}">\n'
        f"  <title>{host}</title>\n"
        "  <info>\n"
        '   <metadata owner="http://freedesktop.org">\n'
        '    <bookmark:icon name="network-server"/>\n'
        "   </metadata>\n"
        '   <metadata owner="http://www.kde.org">\n'
        f"    <ID>1900000000/{uid}</ID>\n"
        "   </metadata>\n"
        "  </info>\n"
        " </bookmark>\n"
    )


def main() -> int:
    # plasmashell/Dolphin create the file during session start and we race them.
    # setup-stuff retries the unit as well, but waiting here is cheaper.
    for _ in range(60):
        if os.path.exists(PATH):
            break
        time.sleep(1)
    else:
        print(f"{PATH} never appeared, giving up", file=sys.stderr)
        return 1

    with open(PATH, encoding="utf-8") as fh:
        doc = fh.read()

    me = socket.gethostname()
    added = []
    for uid, (host, href) in enumerate(PLACES):
        # Skip a bookmark pointing at the machine we are running on.
        if host == me or href in doc:
            continue
        cut = doc.rindex("</xbel>")
        doc = doc[:cut] + entry(host, href, uid) + doc[cut:]
        added.append(host)

    if not added:
        print("nothing to add")
        return 0

    with open(PATH, "w", encoding="utf-8") as fh:
        fh.write(doc)
    print("added: " + ", ".join(added))
    return 0


if __name__ == "__main__":
    sys.exit(main())
