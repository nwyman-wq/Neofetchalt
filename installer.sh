#!/bin/bash
set -e

echo "[*] Updating packages..."
apt-get update -y

echo "[*] Installing curl, git, and python3-pip..."
apt-get install -y curl git python3-pip

echo "[*] Cloning Neofetch- repository..."
rm -rf Neofetch-
git clone https://github.com/nwyman-wq/Neofetch-.git

cd Neofetch-

echo "[*] Installing Python package..."
pip install .

echo "[*] Installation complete!"
