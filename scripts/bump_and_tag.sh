#!/usr/bin/env bash
set -euo pipefail

# Script to bump patch version in mod.info, commit, tag and push
#!/usr/bin/env bash
set -euo pipefail

# Usage: bump_and_tag.sh [--dry-run]
# If --dry-run is provided, commands are printed but not executed.
DRY_RUN=0
if [[ ${1-} == "--dry-run" ]]; then
	DRY_RUN=1
	echo "[dry-run] Simulating bump_and_tag.sh"
	shift
fi

# Wrapper to run or echo commands
run_cmd() {
	echo "+ $*"
	if [[ $DRY_RUN -eq 0 ]]; then
		"$@"
	fi
}

# Script to bump patch version in mod.info, commit, tag and push
# Uses env vars: GITHUB_TOKEN, GITHUB_ACTOR, GITHUB_REPOSITORY
MODINFO_FILE="mod.info"

run_cmd git config user.name "github-actions"
run_cmd git config user.email "actions@github.com"

# Read current version
VERSION=$(grep '^version=' "$MODINFO_FILE" | cut -d'=' -f2)
IFS='.' read -r MAJ MIN PATCH <<< "$VERSION"

# Bump patch
PATCH=$((PATCH+1))
NEW_VERSION="$MAJ.$MIN.$PATCH"

# Update version in file
echo "Updating version $VERSION -> $NEW_VERSION in $MODINFO_FILE"
run_cmd sed -i "s/^version=.*/version=$NEW_VERSION/" "$MODINFO_FILE"

# If dry-run, exit before using GitHub credentials
if [[ $DRY_RUN -eq 1 ]]; then
	echo "[dry-run] Would commit, tag and push Release v$NEW_VERSION"
	exit 0
fi

# Commit, tag, and push
run_cmd git add "$MODINFO_FILE"
run_cmd git commit -m "Release v$NEW_VERSION"
run_cmd git tag "v$NEW_VERSION"
# Push to master and tags
REMOTE="https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
run_cmd git push "$REMOTE" "HEAD:master"
run_cmd git push "$REMOTE" "v$NEW_VERSION"

# Output new version for GitHub Actions
echo "::set-output name=new_version::$NEW_VERSION"