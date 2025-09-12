#!/usr/bin/env bash
#!/usr/bin/env bash
set -euo pipefail

# Usage: upload_workshop.sh [--dry-run] <app_id> <username> <password> <workshop_item_id> <new_version>
# If --dry-run is provided, prints the generated VDF and Docker command without executing.
DRY_RUN=0
if [[ ${1-} == "--dry-run" ]]; then
  DRY_RUN=1
  echo "[dry-run] Simulating upload_workshop.sh"
  shift
fi

# Usage: upload_workshop.sh STEAM_APP_ID STEAM_USERNAME STEAM_PASSWORD STEAM_WORKSHOP_ITEM_ID NEW_VERSION
# Validate args count
if [ $# -ne 5 ]; then
  echo "Usage: $0 [--dry-run] <app_id> <username> <password> <workshop_item_id> <new_version>"
  exit 1
fi

STEAM_APP_ID="$1"
STEAM_USERNAME="$2"
STEAM_PASSWORD="$3"
STEAM_WORKSHOP_ITEM_ID="$4"
NEW_VERSION="$5"

generate_vdf() {
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
}
run_cmd() {
  echo "+ $*"
  if [[ $DRY_RUN -eq 0 ]]; then
    "$@"
  fi
}
echo "Generating workshop.vdf"
generate_vdf
if [[ $DRY_RUN -eq 1 ]]; then
  echo "[dry-run] workshop.vdf content:"
  cat workshop.vdf
  echo "[dry-run] Skipping Docker upload"
  exit 0
fi

# Upload to Steam Workshop via Docker
run_cmd docker run --rm \
  -v "$(pwd):/workspace" \
  -w /workspace \
  cm2network/steamcmd:latest \
  /steamcmd/steamcmd.sh \
    +login "$STEAM_USERNAME" "$STEAM_PASSWORD" \
    +workshop_build_item workshop.vdf \
    +quit
