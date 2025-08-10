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

echo "[*] Installing Python dependencies..."
pip install --break-system-packages -r requirements.txt

echo "[*] Installing Neofetch++ from setup.py..."
pip install --break-system-packages .

# Always install globally for root
INSTALL_PATH="/usr/local/bin"
mkdir -p "$INSTALL_PATH"

echo "[*] Creating fetch command..."
cat << EOF > "$INSTALL_PATH/fetch"
#!/bin/bash
python3 "$(pwd)/neo.py" "\$@"
EOF

chmod +x "$INSTALL_PATH/fetch"

# Make sure /usr/local/bin is in PATH now
if [[ ":$PATH:" != *":/usr/local/bin:"* ]]; then
    export PATH="/usr/local/bin:$PATH"
fi

echo "[*] Done!"
echo "Run it now with: fetch"
