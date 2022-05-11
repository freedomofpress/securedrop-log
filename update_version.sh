#!/bin/bash
## Usage: ./update_version.sh <version>

set -e

readonly NEW_VERSION=$1

if [ -z "$NEW_VERSION" ]; then
  echo "You must specify the new version!"
  exit 1
fi

# Get the old version from VERSION
OLD_VERSION=$(cat VERSION)
if [ -z "$OLD_VERSION" ]; then
  echo "Couldn't find the old version: does this script need to be updated?"
  exit 1
fi

# Update the version in VERSION (setup.py is done automatically)
if [[ "$OSTYPE" == "darwin"* ]]; then
    # The empty '' after sed -i is required on macOS to indicate no backup file should be saved.
    sed -i '' "s@$(echo "${OLD_VERSION}" | sed 's/\./\\./g')@$NEW_VERSION@g" VERSION
else
    sed -i "s@$(echo "${OLD_VERSION}" | sed 's/\./\\./g')@$NEW_VERSION@g" VERSION
fi

# Add a new entry to debian/changelog
DEBFULLNAME="SecureDrop Team"
DEBEMAIL="securedrop@freedom.press"
dch --newversion "${NEW_VERSION}" --distribution $(dpkg-parsechangelog -S distribution) "see changelog.md"
