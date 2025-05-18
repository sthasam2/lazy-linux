#!/bin/bash

PARENT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$PARENT_DIR/../../utils.sh"

if command_exists "starship"; then
    echo "'starship' already exists. Skipping"
else
    curl -sS https://starship.rs/install.sh | sh
fi

SHELL_CONFIG_FILE=""
STARSHIP_ACTIVATE_SCRIPT=""

if [[ "$SHELL" == *"/zsh" ]]; then
    SHELL_CONFIG_FILE="$HOME/.zshrc"
    STARSHIP_ACTIVATE_SCRIPT='eval "$(starship init zsh)'
else
    SHELL_CONFIG_FILE="$HOME/.bashrc"
    STARSHIP_ACTIVATE_SCRIPT='eval "$(starship init bash)'
fi

# Check and add to shell config if not already present
if ! grep -Fxq "$STARSHIP_ACTIVATE_SCRIPT" "$SHELL_CONFIG_FILE"; then
    echo "Adding starship activation to $SHELL_CONFIG_FILE..."
    echo "$STARSHIP_ACTIVATE_SCRIPT" >>"$SHELL_CONFIG_FILE"
else
    echo "Starship activation already present in $SHELL_CONFIG_FILE."
fi

source $SHELL_CONFIG_FILE
