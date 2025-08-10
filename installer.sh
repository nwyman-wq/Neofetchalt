#!/bin/bash
set -e

# Colors
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
CYAN="\e[36m"
BOLD="\e[1m"
RESET="\e[0m"

# Pretty print function
info()    { echo -e "${CYAN}[*]${RESET} $1"; }
success() { echo -e "${GREEN}[✔]${RESET} $1"; }
warn()    { echo -e "${YELLOW}[!]${RESET} $1"; }
error()   { echo -e "${RED}[✘]${RESET} $1"; exit 1; }

info "Updating packages..."
apt-get update -y || error "Failed to update packages."

info "Installing dependencies (curl, git, python3-pip)..."
apt-get install -y curl git python3-pip || error "Failed to install dependencies."

info "Removing any old Fetch installation..."
rm -rf /usr/bin/Fetch /usr/local/bin/fetch

info "Cloning Neofetch++ repository..."
git clone https://github.com/nwyman-wq/Neofetch-.git || error "Git clone failed."

info "Renaming Neofetch- to Fetch..."
mv Neofetch- Fetch || error "Failed to rename folder."

info "Moving Fetch to /usr/bin..."
mv Fetch /usr/bin/ || error "Failed to move to /usr/bin."

cd /usr/bin/Fetch || error "Failed to enter Fetch directory."

info "Installing Python dependencies..."
pip install --break-system-packages -r requirements.txt || warn "requirements.txt install failed."

info "Installing Neofetch++ from setup.py..."
pip install --break-system-packages . || warn "setup.py install failed."

info "Creating fetch command script..."
cat << 'EOF' > /usr/local/bin/fetch
#!/bin/bash
python3 /usr/bin/Fetch/neo.py "$@"
EOF
chmod +x /usr/local/bin/fetch || error "Failed to make fetch executable."

# Permanent alias
BASHRC="$HOME/.bashrc"
if ! grep -q "alias fetch=" "$BASHRC" 2>/dev/null; then
    echo "alias fetch='python3 /usr/bin/Fetch/neo.py'" >> "$BASHRC"
    success "Added alias to $BASHRC"
fi

# Activate alias now
alias fetch='python3 /usr/bin/Fetch/neo.py'
source "$BASHRC" 2>/dev/null || true

success "Installation complete!"
echo -e "${BOLD}Run it with:${RESET} ${GREEN}fetch${RESET}"

clear

cd /

echo "alias fetch='python3 /usr/bin/Fetch/neo.py'" >> ~/.bashrc

source ~/.bashrc

echo Run ( fetch ) 
