# Check and install curl
if command -v curl >/dev/null 2>&1; then
    echo "curl is already installed."
else
    echo "curl not found. Attempting to install..."
    sudo apt install curl
fi
# Add gpg keyring
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
# Use keyring and look at repository
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
# Install
sudo apt update
sudo apt install brave-browser
