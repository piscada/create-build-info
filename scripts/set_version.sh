#!/bin/bash
set -e

# Get Commit Information
COMMIT_DATE=$(git show -s --format=%ci)
COMMIT_ID=$(git rev-parse HEAD)
SHORT_COMMIT_ID=$(git rev-parse --short HEAD)
COMMIT_MESSAGE=$(git log -1 --pretty=%B)
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
RUN_NUMBER=${GITHUB_RUN_NUMBER}

# Determine Version Information
# Use the latest tag as the base version
LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
BASE_VERSION=${LATEST_TAG#v}

# Extract MAJOR, MINOR, PATCH, and PRE_RELEASE if exists
IFS='-.' read -r MAJOR MINOR PATCH PRE_RELEASE_LABEL PRE_RELEASE_NUMBER <<< "$BASE_VERSION"

# Check if BASE_VERSION has pre-release information
if [[ -n "$PRE_RELEASE_LABEL" && -n "$PRE_RELEASE_NUMBER" ]]; then
  # Increment pre-release number
  PRE_RELEASE_NUMBER=$((PRE_RELEASE_NUMBER + 1))
else
  # Initialize pre-release label and number
  PRE_RELEASE_LABEL="ci"
  PRE_RELEASE_NUMBER=1
fi

# Construct Semantic Version
FULL_SEMVER="$MAJOR.$MINOR.$PATCH-$PRE_RELEASE_LABEL.$PRE_RELEASE_NUMBER"
SEMVER="$MAJOR.$MINOR.$PATCH-$PRE_RELEASE_LABEL.$PRE_RELEASE_NUMBER"
MAJOR_MINOR_PATCH="$MAJOR.$MINOR.$PATCH"

# Export variables for subsequent steps
echo "commitdate=$COMMIT_DATE" >> $GITHUB_ENV
echo "pre_releasenumber=$PRE_RELEASE_NUMBER" >> $GITHUB_ENV
echo "pre_releaselabel=$PRE_RELEASE_LABEL" >> $GITHUB_ENV
echo "fullsemver=$FULL_SEMVER" >> $GITHUB_ENV
echo "majorminorpatch=$MAJOR_MINOR_PATCH" >> $GITHUB_ENV
echo "semver=$SEMVER" >> $GITHUB_ENV
echo "major=$MAJOR" >> $GITHUB_ENV
echo "minor=$MINOR" >> $GITHUB_ENV
echo "patch=$PATCH" >> $GITHUB_ENV
echo "commitid=$COMMIT_ID" >> $GITHUB_ENV
echo "shortcommitid=$SHORT_COMMIT_ID" >> $GITHUB_ENV
echo "commitmessage=$COMMIT_MESSAGE" >> $GITHUB_ENV
echo "branchname=$BRANCH_NAME" >> $GITHUB_ENV
echo "runnumber=$RUN_NUMBER" >> $GITHUB_ENV

# Create buildInfo.json
cat > buildInfo.json <<EOF
{
  "CommitDate": "${COMMIT_DATE}",
  "PreReleaseNumber": ${PRE_RELEASE_NUMBER},
  "PreReleaseLabel": "${PRE_RELEASE_LABEL}",
  "FullSemVer": "${FULL_SEMVER}",
  "MajorMinorPatch": "${MAJOR_MINOR_PATCH}",
  "SemVer": "${SEMVER}",
  "Major": ${MAJOR},
  "Minor": ${MINOR},
  "Patch": ${PATCH},
  "CommitId": "${COMMIT_ID}",
  "ShortCommitId": "${SHORT_COMMIT_ID}",
  "CommitMessage": "${COMMIT_MESSAGE}",
  "BranchName": "${BRANCH_NAME}",
  "RunNumber": "${RUN_NUMBER}"
}
EOF

# Display buildInfo.json for debugging
cat buildInfo.json
