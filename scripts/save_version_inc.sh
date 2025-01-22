#!/bin/bash
set -e

# Create version.inc using the full semantic version
echo "#define Version \"${fullsemver}\"" > version.inc
cat version.inc
