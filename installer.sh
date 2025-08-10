#!/bin/bash
set -e

echo "[*] Updating packages..."
apt-get update -y

echo "[*] Installing dependencies (curl, git, python3-pip)..."
apt-get install -y curl git python3-pip

echo "[*] Removing any old Fetch installation..."
rm -rf /usr/bin/Fetch

echo "[*] Cloning Neofetch++ repository..."
git clone https://github.com/nwyman-wq/Neofetch-.git

echo "[*] Renaming Neofetch- to Fetch..."
mv Neofetch- Fetch

echo "[*] Moving Fetch to /usr/bin..."
mv Fetch /usr/bin/

cd /usr/bin/Fetch

echo "[*] Installing Python dependencies..."
pip install --break-system-packages -r requirements.txt

echo "[*] Installing Neofetch++ from setup.py..."
pip install --break-system-packages .

# Create /usr/local/bin/fetch script for universal command
echo "[*] Creating fetch command..."
cat << 'EOF' > /usr/local/bin/fetch
#!/bin/bash
python3 /usr/bin/Fetch/neo.py "$@"
EOF
chmod +x /usr/local/bin/fetch

# Add permanent alias to ~/.bashrc
BASHRC="$HOME/.bashrc"
if ! grep -q "alias fetch=" "$BASHRC"; then
    echo "alias fetch='python3 /usr/bin/Fetch/neo.py'" >> "$BASHRC"
    echo "[*] Added alias to $BASHRC"
fi

# Apply alias immediately
alias fetch='python3 /usr/bin/Fetch/neo.py'

# Removing the Extra Details
clear
cd ~
echo "[*] Done!"
echo "You can run it now with: fetch"
