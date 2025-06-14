#!/bin/bash

PARENT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$PARENT_DIR/../../utils.sh"

if command_exists "lsd"; then
  echo "'lsd' already exists. Skipping"
else
  sudo apt install -y lsd
fi
