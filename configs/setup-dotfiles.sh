#!/bin/bash

set -euo pipefail

FILE_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

source "$FILE_DIR/../utils.sh"
source "$FILE_DIR/../repos.sh"

TEMP_DIR="$FILE_DIR/temp_dotfiles"
DOTFILE_BACKUP_DIR="$BACKUP_DIR/dotfiles.$(date +%Y%m%d%H%M%S)"

RESTORE_FLAG=0
declare -a CONFLICTING_FILES=()

# Function to restore backed up files
restore_backup() {
    echo "Error occurred during removal. Attempting to restore backed up files..."
    find "$DOTFILE_BACKUP_DIR" -type f -print0 | while IFS= read -r -d $'\0' backup_file; do
        relative_backup_path="${backup_file#$DOTFILE_BACKUP_DIR/}"
        original_file="$HOME/$relative_backup_path"

        echo "Restoring '$original_file' from '$backup_file'..."
        cp -p "$backup_file" "$original_file" || {
            echo "Error restoring '$original_file'. Please check permissions."
            exit 1
        }
    done
    echo "Restoration complete."
}

# Find conflicting files between temp dotfiles and $HOME
find_conflicts() {
    echo "Scanning for conflicting files (ignoring .git)..."
    while IFS= read -r -d '' temp_file; do
        relative_path="${temp_file#$TEMP_DIR/}"
        home_file="$HOME/$relative_path"

        if [ -f "$home_file" ]; then
            CONFLICTING_FILES+=("$home_file")
        fi
    done < <(find "$TEMP_DIR" -type d -name ".git" -prune -o -type f -print0)
}

# Backup conflicting files to backup directory
backup_conflicts() {
    echo -e "\nFound the following conflicting files:"
    printf " - %s\n" "${CONFLICTING_FILES[@]}"

    read -rp "Do you want to back up these files to '$DOTFILE_BACKUP_DIR'? (y/N): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Backup cancelled by user."
        exit 0
    fi

    echo "Backing up conflicting files to '$DOTFILE_BACKUP_DIR'..."
    mkdir -p "$DOTFILE_BACKUP_DIR"

    for home_file in "${CONFLICTING_FILES[@]}"; do
        relative_path="${home_file#$HOME/}"
        backup_file="$DOTFILE_BACKUP_DIR/$relative_path"
        mkdir -p "$(dirname "$backup_file")"

        echo "Backing up '$home_file' to '$backup_file'..."
        cp -p "$home_file" "$backup_file" || {
            echo "Error backing up '$home_file'."
            exit 1
        }
    done
}

# Function to remove conflicting files
remove_conflicts() {
    echo -e "\nFound the following conflicting files:"
    printf " - %s\n" "${CONFLICTING_FILES[@]}"

    read -rp "Do you want to remove all these original files? (y/N): " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo "Removing original conflicting files..."
        for file in "${CONFLICTING_FILES[@]}"; do
            echo "Removing '$file'..."
            rm "$file" || {
                echo "Error removing '$file'. Restoration will be attempted."
                RESTORE_FLAG=1
                exit 1
            }
        done
        echo "All conflicting files removed."
    else
        echo "Skipped removal of original files."
    fi
}

# Function to copy config files to $HOME dir
copy_configs() {
    echo "Copying config files to $HOME..."

    while IFS= read -r -d '' temp_file; do
        relative_path="${temp_file#$TEMP_DIR/}"
        home_file="$HOME/$relative_path"
        source_file="$TEMP_DIR/$relative_path"

        # Create parent directory in home if it doesn't exist
        mkdir -p "$(dirname "$home_file")"

        echo "Copying '$source_file' to '$home_file'..."
        cp -p "$source_file" "$home_file" || {
            echo "Failed to copy '$source_file' to '$home_file'."
            exit 1
        }
    done < <(find "$TEMP_DIR" -type d -name ".git" -prune -o -type f -print0)

    echo "Initializing dotfiles repository at '$HOME'..."
    local home_dot_git="$HOME/.git"
    local temp_dot_git="$TEMP_DIR/.git"
    if check_dir_exists $home_dot_git; then
        read -rp "Do you want to reinitialize git repository? (y/N): " response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            rm -rf $home_dot_git
        fi
    fi
    cp -r $temp_dot_git $HOME
    echo "All config files copied successfully."
}

cleanup_temp_dir() {
    if [ -d "$TEMP_DIR" ]; then
        echo "Removing temporary directory '$TEMP_DIR'..."
        rm -rf "$TEMP_DIR"
        echo "Temporary directory removed."
    fi
}

# Trap exit signals to attempt restoration
trap '[[ $RESTORE_FLAG -eq 1 ]] && restore_backup' ERR

# Clone repo if not present
if check_dir_exists "$TEMP_DIR"; then
    echo "$TEMP_DIR already exists. Skipping cloning."
else
    echo "Cloning dotfiles repository to '$TEMP_DIR'..."
    git clone "$DOTFILES_REPO_URL" "$TEMP_DIR" || {
        echo "Error cloning repository."
        exit 1
    }
fi

echo "Checking for potential conflicts..."
find_conflicts

if [ ${#CONFLICTING_FILES[@]} -gt 0 ]; then
    backup_conflicts
    remove_conflicts
else
    echo "No conflicts found."
fi

echo "Conflict resolution complete."
if [ "$RESTORE_FLAG" -eq 0 ]; then
    echo "No errors occurred. You may remove the backup directory '$DOTFILE_BACKUP_DIR' if you're satisfied."
fi

copy_configs
cleanup_temp_dir
