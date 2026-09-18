#!/bin/bash
# Downloads the current latest iw4x/launcher Linux release into the directory given as $1,
# but skips the download entirely if the installed launcher already reports that version.
#
# Exists because AMP's built-in "GitHub Release" update source pins an exact asset
# filename that the upstream project periodically renames/removes, breaking updates.
set -e

BASEDIR="$1"
if [ -z "$BASEDIR" ]; then
  echo "usage: resolve-launcher.sh <target-dir>" >&2
  exit 1
fi

API='https://api.github.com/repos/iw4x/launcher/releases/latest'
RELEASE_JSON=$(curl -s "$API")

LATEST_TAG=$(echo "$RELEASE_JSON" | grep -oE '"tag_name": *"[^"]*"' | head -1 | sed -E 's/.*"([^"]+)"$/\1/')
if [ -z "$LATEST_TAG" ]; then
  echo "Could not resolve latest AlterWare launcher release tag" >&2
  exit 1
fi

CURRENT_VERSION=""
if [ -x "${BASEDIR}iw4x-launcher" ]; then
  CURRENT_VERSION=$("${BASEDIR}iw4x-launcher" --version 2>/dev/null | grep -oE '[0-9][0-9a-zA-Z.\-]*' | head -1)
fi

# LATEST_TAG looks like "v1.1.8-b.18"; --version reports "1.1.8-b.18" (no leading v)
if [ "v$CURRENT_VERSION" = "$LATEST_TAG" ]; then
  echo "iw4x-launcher already at latest ($LATEST_TAG), skipping download"
  exit 0
fi

URL=$(echo "$RELEASE_JSON" | grep -oE '"browser_download_url": *"[^"]*linux[^"]*"' | grep -vi release-tool | head -1 | sed -E 's/.*"(https:[^"]+)"/\1/')
if [ -z "$URL" ]; then
  echo "Could not resolve latest AlterWare launcher asset URL" >&2
  exit 1
fi

curl -sL -o "${BASEDIR}launcher.tar.xz" "$URL"
tar -xf "${BASEDIR}launcher.tar.xz" -C "${BASEDIR}"
rm -f "${BASEDIR}launcher.tar.xz"
echo "Installed iw4x-launcher $LATEST_TAG"
