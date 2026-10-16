#!/usr/bin/env bash

set -euo pipefail

BASE_URL="https://downloads.claude.ai/claude-code-releases"
PLATFORM="linux-x64"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
FLAKE_FILE="$ROOT_DIR/flake.nix"

if [ ! -f "$FLAKE_FILE" ]; then
    echo "Error: flake.nix not found at $FLAKE_FILE"
    exit 1
fi

if [ $# -ge 1 ] && [ -n "$1" ]; then
    VERSION="$1"
else
    echo "Version not specified, fetching latest..."
    if ! VERSION=$(curl -fsSL "$BASE_URL/latest"); then
        echo "Error: Failed to fetch latest Claude Code version"
        exit 1
    fi
fi

MANIFEST_URL="$BASE_URL/$VERSION/manifest.zst.json"

echo "Fetching Claude Code $VERSION manifest from:"
echo "  $MANIFEST_URL"

if ! MANIFEST=$(curl -fsSL "$MANIFEST_URL"); then
    echo "Error: Failed to fetch manifest from $MANIFEST_URL"
    exit 1
fi

BINARY=$(jq -er ".platforms[\"$PLATFORM\"].binary" <<<"$MANIFEST")
HEX_HASH=$(jq -er ".platforms[\"$PLATFORM\"].checksum" <<<"$MANIFEST")

echo "Binary: $BINARY"
echo "Hex checksum: $HEX_HASH"

if ! SRI_HASH=$(nix hash convert --hash-algo sha256 --to sri "$HEX_HASH"); then
    echo "Error: Failed to convert hash to SRI format"
    exit 1
fi

echo "SRI hash: $SRI_HASH"

echo "Updating $FLAKE_FILE..."
sed -i "/claude-code = prev.claude-code.override {/,/^ *};$/ {
    s|version = \"[^\"]*\";|version = \"${VERSION}\";|
    s|binary = \"[^\"]*\";|binary = \"${BINARY}\";|
    s|checksum = \"[^\"]*\";|checksum = \"${SRI_HASH}\";|
}" "$FLAKE_FILE"

if command -v nixfmt &>/dev/null; then
    echo "Formatting $FLAKE_FILE..."
    nixfmt "$FLAKE_FILE"
fi

echo "Verifying Nix syntax..."
if nix-instantiate --parse "$FLAKE_FILE" >/dev/null; then
    echo "Success! Claude Code successfully updated to $VERSION"
else
    echo "Warning: Claude Code updated, but syntax verification failed."
    exit 1
fi
