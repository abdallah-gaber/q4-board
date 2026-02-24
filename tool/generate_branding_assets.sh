#!/usr/bin/env bash
set -euo pipefail

mkdir -p assets/branding

ICON_OUT="assets/branding/q4_icon.png"
SPLASH_OUT="assets/branding/q4_splash_mark.png"

# Temporary matrix-first brand mark:
# a premium 2x2 sticky-note board motif (Eisenhower Matrix) for launcher icon.
magick -size 1024x1024 xc:none \
  -fill '#F4F6F9' -stroke '#DCE4EE' -strokewidth 4 \
  -draw 'roundrectangle 72,72 952,952 220,220' \
  -fill '#FBFCFE' -stroke '#E3EAF2' -strokewidth 3 \
  -draw 'roundrectangle 154,154 870,870 92,92' \
  \
  -fill '#F9F1EA' -stroke '#E9D9CD' -strokewidth 2 \
  -draw 'roundrectangle 186,186 510,510 44,44' \
  -fill '#E69A74' -stroke none \
  -draw 'roundrectangle 186,186 510,228 28,28' \
  \
  -fill '#EEF6EC' -stroke '#D8E8D7' -strokewidth 2 \
  -draw 'roundrectangle 546,186 838,510 44,44' \
  -fill '#83BA87' -stroke none \
  -draw 'roundrectangle 546,186 838,228 28,28' \
  \
  -fill '#EDF3FA' -stroke '#D8E3EF' -strokewidth 2 \
  -draw 'roundrectangle 186,546 510,838 44,44' \
  -fill '#7CA8D8' -stroke none \
  -draw 'roundrectangle 186,546 510,588 28,28' \
  \
  -fill '#F4F1F7' -stroke '#E2DDEE' -strokewidth 2 \
  -draw 'roundrectangle 546,546 838,838 44,44' \
  -fill '#A69AB9' -stroke none \
  -draw 'roundrectangle 546,546 838,588 28,28' \
  \
  -fill none -stroke '#2A6F97' -strokewidth 22 \
  -draw 'path \"M 268,357 L 324,413 L 430,307\"' \
  \
  -stroke '#526476' -strokewidth 16 \
  -draw 'line 600,342 770,342' \
  -draw 'line 600,388 736,388' \
  -draw 'line 600,434 748,434' \
  \
  -draw 'line 238,658 458,658' \
  -draw 'line 238,706 430,706' \
  -draw 'line 238,754 390,754' \
  \
  -draw 'line 598,658 778,658' \
  -draw 'line 598,706 726,706' \
  -draw 'line 598,754 760,754' \
  "$ICON_OUT"

# Splash mark UX: use a simpler matrix glyph (less detail than launcher icon)
# so it reads quickly on startup in both light and dark themes.
magick \
  -size 640x640 xc:none \
  -fill '#FBFCFE' -stroke '#DCE4EE' -strokewidth 3 \
  -draw 'roundrectangle 68,68 572,572 120,120' \
  -fill '#F9F1EA' -stroke '#E9D9CD' -strokewidth 2 \
  -draw 'roundrectangle 106,106 320,320 34,34' \
  -fill '#EEF6EC' -stroke '#D8E8D7' -strokewidth 2 \
  -draw 'roundrectangle 352,106 534,320 34,34' \
  -fill '#EDF3FA' -stroke '#D8E3EF' -strokewidth 2 \
  -draw 'roundrectangle 106,352 320,534 34,34' \
  -fill '#F4F1F7' -stroke '#E2DDEE' -strokewidth 2 \
  -draw 'roundrectangle 352,352 534,534 34,34' \
  -fill none -stroke '#2A6F97' -strokewidth 12 \
  -draw 'path \"M 154,220 L 190,256 L 252,194\"' \
  PNG32:"$SPLASH_OUT"

echo "Generated: $ICON_OUT"
echo "Generated: $SPLASH_OUT"
