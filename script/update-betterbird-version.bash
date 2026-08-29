#!/usr/bin/env bash

set -euo pipefail

if [ $# -lt 1 ] || [ -z "$1" ]; then
    echo "Error: Version not specified."
    echo "Usage: $0 <version>"
    echo "Example: $0 140.12.0esr-bb24"
    exit 1
fi

VERSION="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PKG_FILE="$ROOT_DIR/pkgs/by-name/be/betterbird/package.nix"

if [ ! -f "$PKG_FILE" ]; then
    echo "Error: Betterbird package file not found at $PKG_FILE"
    exit 1
fi

URL="https://www.betterbird.eu/downloads/LinuxArchive/betterbird-${VERSION}.en-US.linux-x86_64.tar.xz"

echo "Prefetching Betterbird version $VERSION from:"
echo "  $URL"

if ! BASE32_HASH=$(nix-prefetch-url --type sha256 "$URL"); then
    echo "Error: Failed to prefetch Betterbird archive from $URL"
    exit 1
fi

echo "Fetched base32 hash: $BASE32_HASH"

if ! SRI_HASH=$(nix hash convert --to sri "sha256:$BASE32_HASH"); then
    echo "Error: Failed to convert hash to SRI format"
    exit 1
fi

BASE64_HASH="${SRI_HASH#sha256-}"
NEW_HASH="sha256:${BASE64_HASH}"

echo "New SRI hash (base64): $BASE64_HASH"

echo "Updating $PKG_FILE..."
sed -i "s/version = \"[^\"]*\";/version = \"${VERSION}\";/" "$PKG_FILE"
sed -i "s|hash = \"sha256:[^\"]*\";|hash = \"${NEW_HASH}\";|" "$PKG_FILE"

if command -v nixfmt &>/dev/null; then
    echo "Formatting $PKG_FILE..."
    nixfmt "$PKG_FILE"
fi

echo "Verifying Nix syntax..."
if nix-instantiate --parse "$PKG_FILE" >/dev/null; then
    echo "Success! Betterbird successfully updated to $VERSION"
else
    echo "Warning: Betterbird updated, but syntax verification failed."
    exit 1
fi
