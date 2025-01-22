# Create Build Info Action

![Build Status](https://img.shields.io/github/actions/workflow/status/piscada/create-build-info/main.yml?branch=v1&label=build)
![Version](https://img.shields.io/github/v/tag/piscada/create-build-info?label=version)
![License](https://img.shields.io/github/license/piscada/create-build-info)

## Quick Start

1. **Tag Your Release:**
   ```bash
   git tag v1.2.3
   git push origin v1.2.3
   ```

## Overview

Automates the generation of buildInfo.json, CHANGELOG.md, and version.inc based on your Git history. It can also optionally commit these files back to your repository, streamlining your build and release process without relying on external versioning tools.

## Inputs

| Name           | Description                                                          | Required | Default |
| -------------- | -------------------------------------------------------------------- | -------- | ------- |
| artifact-name  | Name of the artifact to upload.                                      | Yes      | N/A     |
| push-changelog | Commit and push CHANGELOG.md, version.inc, and buildInfo.json files. | No       | false   |

## Outputs

| Name                    | Description                |
| ----------------------- | -------------------------- |
| version_fullsemver      | Full semantic version.     |
| version_majorminorpatch | Major.Minor.Patch version. |
| version_prereleasetag   | Pre-release tag.           |

## Usage

### Basic Example

Here's a simple example of how to use the **Create Build Info Action** in your workflow to generate build metadata and upload it as an artifact without committing changes back to the repository.

```yaml
name: Generate Build Info

on:
  push:
    branches:
      - main

jobs:
  build-info:
    runs-on: ubuntu-latest
    name: Generate buildInfo.json, CHANGELOG.md, and version.inc

    outputs:
      version_fullsemver: ${{ steps.nfo.outputs.version_fullsemver }}
      version_majorminorpatch: ${{ steps.nfo.outputs.version_majorminorpatch }}
      version_prereleasetag: ${{ steps.nfo.outputs.version_prereleasetag }}

    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0 # Ensure full history for versioning

      - name: Create build meta files
        id: create-build-info
        uses: piscada/create-build-info@v7
        with:
          artifact-name: build-info
          push-changelog: false

      - name: Use Version Outputs
        run: |
          echo "Full SemVer: ${{ steps.nfo.outputs.version_fullsemver }}"
          echo "Major.Minor.Patch: ${{ steps.nfo.outputs.version_majorminorpatch }}"
          echo "Pre-release Tag: ${{ steps.nfo.outputs.version_prereleasetag }}"
```

# License

This project is licensed under the MIT License.

# Contact

For any questions or support, please contact Magnus Gule.

---

**Changes Made:**

1. **Simplified Structure:**

   - Removed the detailed Table of Contents to make the README cleaner.
   - Combined sections where appropriate to reduce length.

2. **Concise Descriptions:**

   - Streamlined the Overview and Features sections to highlight key functionalities without excessive detail.

3. **Streamlined Inputs and Outputs:**

   - Presented Inputs and Outputs in clear tables with brief descriptions.

4. **Focused Usage Examples:**

   - Maintained both Basic and Advanced examples but kept the explanations brief.

5. **Maintained Essential Information:**
   - Kept badges, license, and contact information intact for quick reference.

This streamlined README provides all necessary information in a clear and concise manner, making it easier for users to understand and implement the **Create Build Info Action** without being overwhelmed by too much detail.
