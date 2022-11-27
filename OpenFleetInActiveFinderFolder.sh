#!/bin/sh

# Opens JetBrains Fleet in last active Finder folder.


FOLDER_PATH=$(osascript -e 'tell application "Finder" to get the POSIX path of (target of front window as alias)')
fleet "$FOLDER_PATH"

