#!/usr/bin/env bash
set -euo pipefail

# Download Flutter SDK (stable) into a local folder
FLUTTER_VERSION="3.41.0"
curl -L "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" -o flutter.tar.xz
tar -xf flutter.tar.xz

# IMPORTANT: mark flutter dir as safe for git (Vercel runs in a container user that triggers git safety)
git config --global --add safe.directory "$PWD/flutter"

export PATH="$PWD/flutter/bin:$PATH"

flutter --version
flutter config --enable-web
flutter pub get

# Build release web output
flutter build web --release --base-href "/"
