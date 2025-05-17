sudo apt update -y && sudo apt install -y gpg sudo wget curl
sudo install -dm 755 /etc/apt/keyrings
wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/mise-archive-keyring.gpg 1>/dev/null
echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=amd64] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list
sudo apt update
sudo apt install -y mise

SHELL_CONFIG_FILE=""
MISE_ACTIVATE_SCRIPT=""

if [[ "$SHELL" == *"/zsh" ]]; then
    SHELL_CONFIG_FILE="$HOME/.zshrc"
    MISE_ACTIVATE_SCRIPT='eval "$(/usr/bin/mise activate zsh)"'
else
    SHELL_CONFIG_FILE="$HOME/.bashrc"
    MISE_ACTIVATE_SCRIPT='eval "$(/usr/bin/mise activate bash)"'
fi

# Check and add to shell config if not already present
if ! grep -Fxq "$MISE_ACTIVATE_SCRIPT" "$SHELL_CONFIG_FILE"; then
    echo "Adding mise activation to $SHELL_CONFIG_FILE..."
    echo "$MISE_ACTIVATE_SCRIPT" >>"$SHELL_CONFIG_FILE"
else
    echo "Mise activation already present in $SHELL_CONFIG_FILE."
fi

source $SHELL_CONFIG_FILE

mise install
mise doctor
