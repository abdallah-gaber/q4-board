#!/usr/bin/env bash
set -euo pipefail

mkdir -p assets/branding

ICON_OUT="assets/branding/q4_icon.png"
SPLASH_OUT="assets/branding/q4_splash_mark.png"

# Temporary geometric Q4 mark for pre-Phase-2 branding.
magick -size 1024x1024 xc:none \
  -fill '#EDF3FA' -stroke '#D7E1EE' -strokewidth 4 \
  -draw 'roundrectangle 72,72 952,952 220,220' \
  -fill none -stroke '#1F517A' -strokewidth 34 \
  -draw 'circle 400,410 400,270' \
  -draw 'line 500,510 585,595' \
  -fill '#2A6F97' -stroke none \
  -draw 'roundrectangle 615,300 665,595 18,18' \
  -draw 'polygon 665,445 785,445 665,300' \
  -fill '#18324B' \
  -draw 'roundrectangle 210,705 820,760 28,28' \
  -fill '#2A6F97' \
  -draw 'roundrectangle 210,785 620,835 22,22' \
  "$ICON_OUT"

# Splash mark: compose a soft paper tile under the icon (correct order) and
# force PNG32 to avoid accidental grayscale/1-bit output.
magick \
  \( -size 1200x1200 xc:none -fill '#EEF3F9' -stroke '#DCE5F0' -strokewidth 3 \
     -draw 'roundrectangle 0,0 1199,1199 260,260' \) \
  \( "$ICON_OUT" -resize 640x640 \) \
  -gravity center -composite \
  -resize 640x640 \
  PNG32:"$SPLASH_OUT"

echo "Generated: $ICON_OUT"
echo "Generated: $SPLASH_OUT"
