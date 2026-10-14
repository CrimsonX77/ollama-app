#!/usr/bin/env bash
# Vercel build script: installs the Flutter SDK and compiles the web build.
# Vercel's build image has no Flutter, so we fetch the pinned stable release.
set -euo pipefail

FLUTTER_VERSION="3.29.0"
FLUTTER_DIR="${FLUTTER_DIR:-/tmp/flutter-sdk}"

if [ ! -x "$FLUTTER_DIR/bin/flutter" ]; then
  echo "Downloading Flutter $FLUTTER_VERSION..."
  curl -sL -o /tmp/flutter.tar.xz "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
  mkdir -p "$FLUTTER_DIR"
  tar -xJf /tmp/flutter.tar.xz -C "$FLUTTER_DIR" --strip-components=1
  rm -f /tmp/flutter.tar.xz
fi

# The Flutter tool shells out to git and refuses to run from an untrusted dir.
git config --global --add safe.directory "$FLUTTER_DIR" 2>/dev/null || true
export PATH="$FLUTTER_DIR/bin:$PATH"

flutter config --no-analytics --enable-web
flutter pub get
flutter build web --release
