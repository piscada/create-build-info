#!/bin/bash
set -e

echo "# Changelog" > CHANGELOG.md
echo "" >> CHANGELOG.md

# Function to generate commits between two tags
generate_commits() {
    local current_tag=$1
    local previous_tag=$2
    
    echo "## Version $current_tag" >> CHANGELOG.md
    echo "" >> CHANGELOG.md
    echo "### Commits" >> CHANGELOG.md
    echo "" >> CHANGELOG.md
    
    if [ -z "$previous_tag" ]; then
        # If there is no previous tag, list all commits up to HEAD
        git log --pretty=format:'- %s' "$current_tag"..HEAD >> CHANGELOG.md
    else
        git log --pretty=format:'- %s' "$previous_tag".."$current_tag" >> CHANGELOG.md
    fi
    
    echo "" >> CHANGELOG.md
}

# Get the current version
current_version="${fullsemver}"
previous_tag=$(git describe --tags --abbrev=0 "${LATEST_TAG}^" 2>/dev/null || echo "")

# Generate changelog for the current version
generate_commits "$current_version" "$previous_tag"

# Get the last 5 tags excluding pre-release tags
echo "## Previous Versions" >> CHANGELOG.md
echo "" >> CHANGELOG.md

tags=$(git tag --sort=-creatordate | grep -v "${pre_releaselabel}" | head -n 5)

for tag in $tags; do
    # Find the previous tag for each tag
    previous=$(git describe --tags --abbrev=0 "$tag^" 2>/dev/null || echo "")
    
    echo "## Version $tag" >> CHANGELOG.md
    echo "" >> CHANGELOG.md
    echo "### Commits" >> CHANGELOG.md
    echo "" >> CHANGELOG.md
    
    if [ -z "$previous" ]; then
        # If there is no previous tag, list all commits up to this tag
        git log --pretty=format:'- %s' "$tag" >> CHANGELOG.md
    else
        git log --pretty=format:'- %s' "$previous".."$tag" >> CHANGELOG.md
    fi
    
    echo "" >> CHANGELOG.md
    echo "- [$tag](https://github.com/${GITHUB_REPOSITORY}/releases/tag/$tag)" >> CHANGELOG.md
done
