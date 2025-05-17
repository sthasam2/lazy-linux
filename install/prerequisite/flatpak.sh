source ../../utils.sh

# Check and install curl
if command_exists "flatpak"; then
    echo "flatpak is already installed."
else
    echo "Installing 'flatpak'..."
    sudo apt update && sudo apt install -y kde-config-flatpak
fi
echo "Adding 'flathub' repo..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
