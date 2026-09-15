#!/usr/bin/env bash
# Builds the Flutter web bundle on Vercel.
#
# Vercel's build image has no Flutter SDK, so fetch one next to the project and
# use it in place. Nothing here needs an API key, a database or an env var —
# MDGym keeps everything in the browser.
set -euo pipefail

FLUTTER_VERSION="${FLUTTER_VERSION:-stable}"
FLUTTER_DIR="${FLUTTER_DIR:-$PWD/.flutter-sdk}"

if [ ! -x "$FLUTTER_DIR/bin/flutter" ]; then
  echo "==> Fetching Flutter ($FLUTTER_VERSION)"
  rm -rf "$FLUTTER_DIR"
  git clone --depth 1 --branch "$FLUTTER_VERSION" \
    https://github.com/flutter/flutter.git "$FLUTTER_DIR"
else
  echo "==> Reusing cached Flutter at $FLUTTER_DIR"
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

# The SDK refuses to run from a directory owned by another user unless told the
# checkout is trusted, which happens on some CI images.
git config --global --add safe.directory "$FLUTTER_DIR" || true

flutter --version
flutter config --enable-web --no-analytics
flutter pub get
flutter build web --release

echo "==> Built build/web"
