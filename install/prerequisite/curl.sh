sudo apt update
# Check and install curl
if command_exists "curl"; then
    echo "'curl' is already installed."
else
    echo "Installing 'curl'..."
    sudo apt install curl
fi
