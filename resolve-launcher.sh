#!/bin/bash
# Downloads the current latest iw4x/launcher Linux release into the directory given as $1.
# Exists because AMP's built-in "GitHub Release" update source pins an exact asset
# filename that the upstream project periodically renames/removes, breaking updates.
set -e

BASEDIR="$1"
if [ -z "$BASEDIR" ]; then
  echo "usage: resolve-launcher.sh <target-dir>" >&2
  exit 1
fi

API='https://api.github.com/repos/iw4x/launcher/releases/latest'
URL=$(curl -s "$API" | grep -oE '"browser_download_url": *"[^"]*linux[^"]*"' | grep -vi release-tool | head -1 | sed -E 's/.*"(https:[^"]+)"/\1/')

if [ -z "$URL" ]; then
  echo "Could not resolve latest AlterWare launcher asset URL" >&2
  exit 1
fi

curl -sL -o "${BASEDIR}launcher.tar.xz" "$URL"
tar -xf "${BASEDIR}launcher.tar.xz" -C "${BASEDIR}"
rm -f "${BASEDIR}launcher.tar.xz"
