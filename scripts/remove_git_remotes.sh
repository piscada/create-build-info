#!/bin/bash
set -e

# Remove all git remotes except origin
remotes=$(git remote)
for remote in $remotes; do
    if [ "$remote" != "origin" ]; then
        git remote remove "$remote"
        echo "Removed remote: $remote"
    fi
done
