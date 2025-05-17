#!/bin/bash

# command_exists: Checks if a command exists in the system's PATH.
# Args: $1 - The name of the command to check.
# Returns: 0 if the command exists, 1 otherwise.
command_exists() { command -v "$1" >/dev/null 2>&1; }

# check_dir_exists: Checks if a directory exists.
# Args: $1 - The path to the directory.
# Returns: 0 if the directory exists, 1 otherwise.
check_dir_exists() { [ -d "$1" ]; }

# check_file_exists: Checks if a regular file exists.
# Args: $1 - The path to the file.
# Returns: 0 if the file exists, 1 otherwise.
check_file_exists() { [ -f "$1" ]; }

# check_dir_or_file_exists: Checks if a directory or a file exists.
# Args: $1 - The path to the directory or file.
# Returns: 0 if it exists, 1 otherwise.
check_dir_or_file_exists() { [ -e "$1" ]; }

# get_abs_dir_path: Gets the directory of the current running script.
# Args: $1 - The source path (usually "${BASH_SOURCE[0]}")
# Returns: Echoes the absolute path to the directory containing the script.
get_abs_dir_path() { cd "$(dirname "$1")" && pwd; }

source ./dirs.sh
if ! check_dir_exists "$LOCAL_BIN_DIR"; then
    mkdir -p "$LOCAL_BIN_DIR"
fi
