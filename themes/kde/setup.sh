#!/bin/bash
GLOBAL_THEME_DIR=$HOME/.local/share/plasma/look-and-feel
PLASMA_THEME_DIR=$HOME/.local/share/plasma/desktoptheme
ICON_THEME_DIR=$HOME/.local/share/icons/
COLOR_SCHEME_DIR=$HOME/.local/share/color-schemes/

extract_tar() {
  local src_dir="$1"
  local dest_dir="$2"

  mkdir -p "$dest_dir"

  for archive in "$src_dir"/*.tar*; do
    [[ -e "$archive" ]] || continue  # Skip if no matching files

    local base_name
    base_name=$(basename "$archive")

      # List files in the archive
    local file_list
    case "$archive" in
      *.tar.gz|*.tgz)    file_list=$(tar -tzf "$archive") ;;
      *.tar.bz2|*.tbz2)  file_list=$(tar -tjf "$archive") ;;
      *.tar.xz|*.txz)    file_list=$(tar -tJf "$archive") ;;
      *.tar)             file_list=$(tar -tf "$archive") ;;
      *)                 echo "Skipping unsupported file: $archive"; continue ;;
    esac

    # Check if any file already exists in destination
    local already_exists=false
    while IFS= read -r file; do
      if [[ -e "$dest_dir/$file" ]]; then
        already_exists=true
        break
      fi
    done <<< "$file_list"

    if $already_exists; then
      echo "$base_name contents already exist, skipping"
      continue
    fi

    echo "Extracting $base_name to $dest_dir"

    case "$archive" in
      *.tar.gz|*.tgz)    tar -xzf "$archive" -C "$dest_dir" ;;
      *.tar.bz2|*.tbz2)  tar -xjf "$archive" -C "$dest_dir" ;;
      *.tar.xz|*.txz)    tar -xJf "$archive" -C "$dest_dir" ;;
      *.tar)             tar -xf "$archive" -C "$dest_dir" ;;
      *)                 echo "Skipping unsupported file: $archive" ;;
    esac
  done
}

# Setup Global Themes
extract_tar "global" $GLOBAL_THEME_DIR

# Setup Plasma Themes
extract_tar "plasma" $PLASMA_THEME_DIR

# Setup Icons
extract_tar "icons" $ICON_THEME_DIR

# Setup Color Schemes
cp color-schemes/* $COLOR_SCHEME_DIR
