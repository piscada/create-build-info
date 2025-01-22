#!/bin/bash
set -e

# Configure Git
git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"

# Add changes
git add CHANGELOG.md buildInfo.json version.inc

# Commit changes
git commit -m "chore: update CHANGELOG.md [skip ci]"

# Push changes
git push origin main
