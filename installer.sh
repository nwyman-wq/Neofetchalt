#!/bin/bash
set -e

echo "[*] Updating packages..."
apt-get update -y

echo "[*] Installing dependencies (curl, git, python3-pip)..."
apt-get install -y curl git python3-pip

echo "[*] Removing any old Neofetch++ directory..."
rm -rf Neofetch-

echo "[*] Cloning Neofetch++ repository..."
git clone https://github.com/nwyman-wq/Neofetch-.git

cd Neofetch-

echo "[*] Installing Neofetch++..."
pip install --user .

# Determine install location for 'fetch'
if [ "$(id -u)" -eq 0 ]; then
    INSTALL_PATH="/usr/local/bin"
else
    INSTALL_PATH="$HOME/.local/bin"
    mkdir -p "$INSTALL_PATH"
    # Ensure ~/.local/bin is in PATH
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        echo "[*] Added ~/.local/bin to your PATH (reload shell to apply)"
    fi
fi

echo "[*] Creating fetch command at $INSTALL_PATH/fetch..."
cat << 'EOF' > "$INSTALL_PATH/fetch"
#!/bin/bash
python3 -m neofetch "$@"
EOF

chmod +x "$INSTALL_PATH/fetch"

echo "[*] Done!"
echo "Run it with: fetch"
