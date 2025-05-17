#!/bin/bash
KANATA_BIN_URL=https://github.com/jtroo/kanata/releases/download/v1.8.1/kanata

PARENT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source $PARENT_DIR/../../utils.sh

echo "Starting kanata installation script"

if command_exists "kanata"; then
  echo "'kanata' is already available at $(which kanata)"
  kanata --version
else
  mkdir -p "$LOCAL_BIN_DIR"
  wget -P "$LOCAL_BIN_DIR" "$KANATA_BIN_URL"
  chmod +x "$LOCAL_BIN_DIR/kanata"
  if ! grep -q "$LOCAL_BIN_DIR" <<<"$PATH"; then
    SHELL_CONFIG_FILE=""
    if [[ "$SHELL" == *"/zsh" ]]; then
      SHELL_CONFIG_FILE="$HOME/.zshrc"
    else
      SHELL_CONFIG_FILE="$HOME/.bashrc"
    fi
    echo "export PATH=\"$PATH:$LOCAL_BIN_DIR\"" >>"$SHELL_CONFIG_FILE"
    source "$SHELL_CONFIG_FILE"
    echo "Added '$LOCAL_BIN_DIR' to PATH in '$SHELL_CONFIG_FILE'. It should take effect in the current and future sessions."
  fi

  log_info "Successfully downloaded 'kanata' binary from $KANATA_BIN_URL and installed to $LOCAL_BIN_DIR"
  echo --version # Optionally check the version after installation
fi

echo "Kanata installation check completed."
