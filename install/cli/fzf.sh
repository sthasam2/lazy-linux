#!/bin/bash

PARENT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$PARENT_DIR/../../utils.sh"

if command_exists "fzf"; then
    echo "'fzf' already exists. Skipping"
else
    curl -sS https://fzf.rs/install.sh | sh
fi

sudo apt install -y fzf
