#!/usr/bin/env python3
"""Print what percentage of an image is near-white background.

variety cannot express this. Its only brightness knob is lightness_enabled +
lightness_mode, which compares the *mean* brightness of the whole image against a
hardcoded 75/255 (VarietyWindow.image_ok). A mean says nothing about how much of
the frame is actually white, and it has two escape hatches: find_images() reruns
the check with a growing `fuzziness` that relaxes the threshold to 99, and if
nothing passes at all it deliberately shows a non-matching image anyway
("Prepared buffer still empty after search, appending some non-ok image").

Near-white is deliberately stricter than "bright": a pixel counts only if it is
both bright and desaturated, so a saturated yellow or pale sky does not read as
white background. Doing this with ImageMagick's -fuzz looked simpler but counts
distance-from-white in RGB, which sweeps in light colours, and it silently
miscounts any image with an alpha channel.
"""

import sys

from PIL import Image

# A pixel is background-white if its darkest channel is still bright...
MIN_CHANNEL = 200
# ...and the channels are close enough together to be grey rather than a colour.
MAX_SPREAD = 30

# 100x100 is what the decision is made on. variety samples 50x50 for its own
# lightness; the extra resolution costs nothing and this runs once per change.
SAMPLE = 100


def white_fraction(path):
    image = Image.open(path).convert("RGB").resize((SAMPLE, SAMPLE))
    # tobytes() rather than getdata(): getdata() is deprecated in Pillow 14, and
    # this runs on every wallpaper change so the warning would be constant noise.
    data = image.tobytes()
    white = 0
    for i in range(0, len(data), 3):
        low = min(data[i], data[i + 1], data[i + 2])
        high = max(data[i], data[i + 1], data[i + 2])
        if low > MIN_CHANNEL and high - low < MAX_SPREAD:
            white += 1
    return 100.0 * white / (len(data) // 3)


if __name__ == "__main__":
    try:
        print(f"{white_fraction(sys.argv[1]):.1f}")
    except Exception as e:
        # An unreadable image must not cause a skip -- fall through as "not white".
        print(f"unreadable: {e}", file=sys.stderr)
        print("0.0")
