# Check and install curl
if command -v flatpak >/dev/null 2>&1; then
    echo "flatpak is already installed."
else
    echo "flatpak not found. Attempting to install..."
    sudo apt update && sudo apt install -y kde-config-flatpak
fi
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
