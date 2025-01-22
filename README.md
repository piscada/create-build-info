# Create Build Info Action

![Build Status](https://img.shields.io/github/actions/workflow/status/piscada/create-build-info/main.yml?branch=v1&label=build)
![Version](https://img.shields.io/github/v/tag/piscada/create-build-info?label=version)
![License](https://img.shields.io/github/license/piscada/create-build-info)

## TLDR update code:

- Remember to `git tag v1.2.3`
- `git push origin v1.2.3`
- Create release on [github.com/piscada/create-build-info](https://github.com/piscada/create-build-info)

## Table of Contents

- [Create Build Info Action](#create-build-info-action)
  - [TLDR update code:](#tldr-update-code)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Features](#features)
  - [Inputs](#inputs)
    - [Input Details](#input-details)
  - [Outputs](#outputs)
    - [Output Details](#output-details)
  - [Usage](#usage)
    - [Basic Example](#basic-example)
    - [Advanced Example with Commit and Push](#advanced-example-with-commit-and-push)
- [License](#license)
- [Contact](#contact)

## Overview

The **Create Build Info Action** is a reusable GitHub Action designed to generate build metadata files (`buildInfo.json`, `CHANGELOG.md`, `version.inc`) and optionally update these files in your repository. This action utilizes custom scripts to determine the semantic version of your project based on your Git history, eliminating the need for external tools like GitVersion. It automates the creation and updating of essential build information files, providing key details about each build.

## Features

- **Automated Versioning:** Generates semantic versioning based on your Git history using custom scripts.
- **Changelog Generation:** Automatically creates or updates `CHANGELOG.md` with commit messages and previous versions.
- **Artifact Uploading:** Uploads generated files (`buildInfo.json`, `CHANGELOG.md`, `version.inc`) as workflow artifacts.
- **Optional Commit of Build Files:** Optionally commits and pushes the updated `CHANGELOG.md`, `version.inc`, and `buildInfo.json` to the main branch.
- **Customizable Artifact Name:** Allows specifying a custom name for the uploaded artifact.
- **Comprehensive Build Information:** Includes fields such as `CommitId`, `ShortCommitId`, `CommitMessage`, `BranchName`, and `RunNumber` in `buildInfo.json`.
- **Modular Script Structure:** Shell scripts are extracted into separate files for better maintainability and readability.

## Inputs

| Input Name       | Description                                                                               | Required | Default |
| ---------------- | ----------------------------------------------------------------------------------------- | -------- | ------- |
| `artifact-name`  | Name of the artifact to upload.                                                           | Yes      | N/A     |
| `push-changelog` | Whether to commit and push the `CHANGELOG.md`, `version.inc`, and `buildInfo.json` files. | No       | `false` |

### Input Details

- **`artifact-name`** (`string`, _required_):  
  Specifies the name of the artifact that will be uploaded. This artifact will contain the generated `buildInfo.json`, `CHANGELOG.md`, and `version.inc` files.

- **`push-changelog`** (`boolean`, _optional_):  
  Determines whether the action should commit and push the updated `CHANGELOG.md`, `version.inc`, and `buildInfo.json` back to the repository. Set to `true` to enable this feature. Defaults to `false`.

## Outputs

| Output Name               | Description                |
| ------------------------- | -------------------------- |
| `version_fullsemver`      | Full semantic version.     |
| `version_majorminorpatch` | Major.Minor.Patch version. |
| `version_prereleasetag`   | Pre-release tag.           |

### Output Details

- **`version_fullsemver`** (`string`):  
  The complete semantic version (e.g., `1.2.3-ci.2409`) determined by the custom versioning logic.

- **`version_majorminorpatch`** (`string`):  
  The major, minor, and patch components of the version (e.g., `1.2.3`).

- **`version_prereleasetag`** (`string`):  
  The pre-release tag associated with the version (e.g., `ci.2409`).

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
      version_fullsemver: ${{ steps.create-build-info.outputs.version_fullsemver }}
      version_majorminorpatch: ${{ steps.create-build-info.outputs.version_majorminorpatch }}
      version_prereleasetag: ${{ steps.create-build-info.outputs.version_prereleasetag }}

    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0 # Ensure full history for versioning

      - name: Create build meta files
        id: create-build-info
        uses: piscada/create-build-info@v1
        with:
          artifact-name: build-info
          push-changelog: false

      - name: Use Version Outputs
        run: |
          echo "Full SemVer: ${{ steps.create-build-info.outputs.version_fullsemver }}"
          echo "Major.Minor.Patch: ${{ steps.create-build-info.outputs.version_majorminorpatch }}"
          echo "Pre-release Tag: ${{ steps.create-build-info.outputs.version_prereleasetag }}"
```

### Advanced Example with Commit and Push

If you want the action to automatically commit and push the updated `CHANGELOG.md`, `version.inc`, and `buildInfo.json` to your repository, set push-changelog to true. Ensure that the GitHub Actions runner has the necessary permissions to push to your repository.

```yaml
name: Generate and Commit Build Info

on:
  push:
    branches:
      - main

jobs:
  build-info:
    runs-on: ubuntu-latest
    name: Generate and Commit buildInfo.json, CHANGELOG.md, and version.inc

    outputs:
      version_fullsemver: ${{ steps.create-build-info.outputs.version_fullsemver }}
      version_majorminorpatch: ${{ steps.create-build-info.outputs.version_majorminorpatch }}
      version_prereleasetag: ${{ steps.create-build-info.outputs.version_prereleasetag }}

    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0 # Ensure full history for versioning

      - name: Create build meta files
        id: create-build-info
        uses: piscada/create-build-info@v1
        with:
          artifact-name: build-info
          push-changelog: true

      - name: Use Version Outputs
        run: |
          echo "Full SemVer: ${{ steps.create-build-info.outputs.version_fullsemver }}"
          echo "Major.Minor.Patch: ${{ steps.create-build-info.outputs.version_majorminorpatch }}"
          echo "Pre-release Tag: ${{ steps.create-build-info.outputs.version_prereleasetag }}"
```

# License

This project is licensed under the MIT License.

# Contact

For any questions or support, please contact Magnus Gule.
