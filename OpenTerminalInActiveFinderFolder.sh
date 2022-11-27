#!/bin/sh

# Opens new terminal window in last active Finder folder.


FOLDER_PATH=$(osascript -e 'tell application "Finder" to get the POSIX path of (target of front window as alias)')
open -a Terminal "$FOLDER_PATH"

