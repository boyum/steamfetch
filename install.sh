#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TAP_NAME="boyum/steamfetch"
TAP_DIR="$(brew --repository)/Library/Taps/boyum/homebrew-steamfetch"

"$ROOT/build.sh"

mkdir -p "$TAP_DIR/Casks" "$TAP_DIR/dist"
rm -f "$TAP_DIR/Formula/steamfetch.rb" "$TAP_DIR/dist/steamfetch-0.1.0.tar.gz"
cp "$ROOT/Casks/steamfetch.rb" "$TAP_DIR/Casks/steamfetch.rb"
cp "$ROOT/dist/"steamfetch-*.zip "$TAP_DIR/dist/"

if brew list --cask steamfetch >/dev/null 2>&1; then
  brew reinstall --cask "$TAP_NAME/steamfetch"
else
  brew install --cask "$TAP_NAME/steamfetch"
fi
