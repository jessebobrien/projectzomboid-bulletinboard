#!/usr/bin/env bash
set -euo pipefail

# Script to bump patch version in mod.info, commit, tag and push
#!/usr/bin/env bash
set -euo pipefail

# Script to bump patch version in mod.info, commit, tag and push
# Uses env vars: GITHUB_TOKEN, GITHUB_ACTOR, GITHUB_REPOSITORY
MODINFO_FILE="mod.info"

git config user.name "github-actions"
git config user.email "actions@github.com"

# Read current version
VERSION=$(grep '^version=' "$MODINFO_FILE" | cut -d'=' -f2)
IFS='.' read -r MAJ MIN PATCH <<< "$VERSION"

# Bump patch
PATCH=$((PATCH+1))
NEW_VERSION="$MAJ.$MIN.$PATCH"

echo "Updating version $VERSION -> $NEW_VERSION in $MODINFO_FILE"
# Update file
sed -i "s/^version=.*/version=$NEW_VERSION/" "$MODINFO_FILE"

# Commit and tag
git add "$MODINFO_FILE"
git commit -m "Release v$NEW_VERSION"
git tag "v$NEW_VERSION"
# Push changes and tags using provided parameters
# Push changes and tags using env credentials
REMOTE="https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
git push "$REMOTE" "HEAD:master"
git push "$REMOTE" "v$NEW_VERSION"

# Set output for GitHub Actions
echo "::set-output name=new_version::$NEW_VERSION"