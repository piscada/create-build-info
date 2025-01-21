# Create Build Info Action

![Build Status](https://img.shields.io/github/actions/workflow/status/piscada/create-build-info/main.yml?branch=v1&label=build)
![Version](https://img.shields.io/github/v/tag/piscada/create-build-info?label=version)
![License](https://img.shields.io/github/license/piscada/create-build-info)

## Table of Contents

- [Create Build Info Action](#create-build-info-action)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Features](#features)
  - [Inputs](#inputs)
    - [Input Details](#input-details)
  - [Outputs](#outputs)
    - [Output Details](#output-details)
  - [Usage](#usage)
    - [Basic Example](#basic-example)

## Overview

The **Create Build Info Action** is a reusable GitHub Action designed to generate build metadata files (`buildInfo.json`, `CHANGELOG.md`, `version.inc`) and optionally update the changelog in your repository. This action leverages [GitVersion](https://gitversion.net/) to determine the semantic version of your project and automates the creation of essential build information files.

## Features

- **Automated Versioning:** Uses GitVersion to generate semantic versioning based on your Git history.
- **Changelog Generation:** Automatically creates or updates `CHANGELOG.md` with commit messages and previous versions.
- **Artifact Uploading:** Uploads generated files (`buildInfo.json`, `CHANGELOG.md`, `version.inc`) as workflow artifacts.
- **Optional Changelog Commit:** Optionally commits and pushes the updated `CHANGELOG.md` to the main branch.
- **Customizable Artifact Name:** Allows specifying a custom name for the uploaded artifact.

## Inputs

| Input Name       | Description                                         | Required | Default |
| ---------------- | --------------------------------------------------- | -------- | ------- |
| `artifact-name`  | Name of the artifact to upload.                     | Yes      | N/A     |
| `push-changelog` | Whether to commit and push the `CHANGELOG.md` file. | No       | `false` |

### Input Details

- **`artifact-name`** (`string`, _required_):  
  Specifies the name of the artifact that will be uploaded. This artifact will contain the generated `buildInfo.json`, `CHANGELOG.md`, and `version.inc` files.

- **`push-changelog`** (`boolean`, _optional_):  
  Determines whether the action should commit and push the updated `CHANGELOG.md` back to the repository. Set to `true` to enable this feature. Defaults to `false`.

## Outputs

| Output Name                  | Description                                |
| ---------------------------- | ------------------------------------------ |
| `gitversion_fullsemver`      | Full semantic version from GitVersion.     |
| `gitversion_majorminorpatch` | Major.Minor.Patch version from GitVersion. |
| `gitversion_prereleasetag`   | Pre-release tag from GitVersion.           |

### Output Details

- **`gitversion_fullsemver`** (`string`):  
  The complete semantic version (e.g., `1.2.3-beta.1`) determined by GitVersion.

- **`gitversion_majorminorpatch`** (`string`):  
  The major, minor, and patch components of the version (e.g., `1.2.3`).

- **`gitversion_prereleasetag`** (`string`):  
  The pre-release tag associated with the version (e.g., `beta.1`).

## Usage

### Basic Example

Here's a simple example of how to use the **Create Build Info Action** in your workflow to generate build metadata and upload it as an artifact.

```yaml
name: Generate Build Info

on:
  push:
    branches:
      - main

jobs:
  build-info:
    runs-on: ubuntu-latest
    name: Generate buildInfo.json and CHANGELOG.md

    outputs:
      gitversion_fullsemver: ${{ steps.create-build-info.outputs.gitversion_fullsemver }}
      gitversion_majorminorpatch: ${{ steps.create-build-info.outputs.gitversion_majorminorpatch }}
      gitversion_prereleasetag: ${{ steps.create-build-info.outputs.gitversion_prereleasetag }}

    steps:
      - name: Create build meta files
        id: create-build-info
        uses: piscada/create-build-info@v1
        with:
          artifact-name: build-info
          push-changelog: false

      - name: Use GitVersion Outputs
        run: |
          echo "Full SemVer: ${{ steps.create-build-info.outputs.gitversion_fullsemver }}"
          echo "Major.Minor.Patch: ${{ steps.create-build-info.outputs.gitversion_majorminorpatch }}"
          echo "Pre-release Tag: ${{ steps.create-build-info.outputs.gitversion_prereleasetag }}"
```
