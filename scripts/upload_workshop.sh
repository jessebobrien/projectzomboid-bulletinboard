#!/usr/bin/env bash
set -euo pipefail

# Usage: upload_workshop.sh STEAM_APP_ID STEAM_USERNAME STEAM_PASSWORD STEAM_WORKSHOP_ITEM_ID NEW_VERSION
if [ $# -ne 5 ]; then
  echo "Usage: $0 <app_id> <username> <password> <workshop_item_id> <new_version>"
  exit 1
fi

STEAM_APP_ID="$1"
STEAM_USERNAME="$2"
STEAM_PASSWORD="$3"
STEAM_WORKSHOP_ITEM_ID="$4"
NEW_VERSION="$5"

# Generate Steam Workshop VDF for publishing
cat <<EOF > workshop.vdf
"workshopitem"
{
  "appid"            "$STEAM_APP_ID"
  "contentfolder"    "$(pwd)"
  "previewfile"      "poster.png"
  "visibility"       "0"
  "changenote"       "Release v$NEW_VERSION"
  "publishedfileid"  "$STEAM_WORKSHOP_ITEM_ID"
}
EOF

# Upload to Steam Workshop via Docker
docker run --rm \
  -v "$(pwd):/workspace" \
  -w /workspace \
  cm2network/steamcmd:latest \
  steamcmd +login "$STEAM_USERNAME" "$STEAM_PASSWORD" +workshop_build_item workshop.vdf +quit
