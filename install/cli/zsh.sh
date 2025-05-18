#!/bin/bash

PARENT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$PARENT_DIR/../../utils.sh"

if command_exists "zsh"; then
    echo "'zsh already installed"
else
    sudo apt install -y zsh
fi
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

source $HOME/.zshrc
