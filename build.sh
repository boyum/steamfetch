#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
VERSION="0.1.0"
DEPOT_VERSION="3.4.0"
CACHE="$ROOT/.cache/depotdownloader-$DEPOT_VERSION"
DIST="$ROOT/dist"
WORK="$(mktemp -d "${TMPDIR:-/tmp}/steamfetch-build.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT

mkdir -p "$CACHE" "$DIST"

fetch() {
  local arch="$1"
  local url="$2"
  local target="$CACHE/$arch.zip"
  if [[ ! -f "$target" ]]; then
    curl -fsSL "$url" -o "$target"
  fi
}

fetch arm64 "https://github.com/SteamRE/DepotDownloader/releases/download/DepotDownloader_${DEPOT_VERSION}/DepotDownloader-macos-arm64.zip"
fetch x64 "https://github.com/SteamRE/DepotDownloader/releases/download/DepotDownloader_${DEPOT_VERSION}/DepotDownloader-macos-x64.zip"

for arch in arm64 x64; do
  mkdir -p "$WORK/$arch"
  unzip -q "$CACHE/$arch.zip" -d "$WORK/$arch"
  cp "$ROOT/bin/steamfetch" "$WORK/$arch/steamfetch"
  chmod +x "$WORK/$arch/steamfetch"
  rm -f "$DIST/steamfetch-$VERSION-$arch.zip"
  (cd "$WORK/$arch" && zip -q -r "$DIST/steamfetch-$VERSION-$arch.zip" steamfetch DepotDownloader)
done

arm_sha="$(shasum -a 256 "$DIST/steamfetch-$VERSION-arm64.zip" | awk '{print $1}')"
x64_sha="$(shasum -a 256 "$DIST/steamfetch-$VERSION-x64.zip" | awk '{print $1}')"

python3 - "$ROOT/Casks/steamfetch.rb" "$arm_sha" "$x64_sha" <<'PY'
import re
import sys

path, arm_sha, x64_sha = sys.argv[1:4]
text = open(path, encoding="utf-8").read()
shas = iter([arm_sha, x64_sha])
text = re.sub(r'sha256 "[0-9a-f]{64}"', lambda _: f'sha256 "{next(shas)}"', text)
with open(path, "w", encoding="utf-8") as handle:
    handle.write(text)
PY

printf 'arm64 sha256: %s\n' "$arm_sha"
printf 'x64 sha256:   %s\n' "$x64_sha"
