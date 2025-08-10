#!/bin/bash
set -e

# Update package lists
apt-get update -y

# Install curl and git
apt-get install -y curl git python3-pip

# Clone the repo
git clone https://github.com/nwyman-wq/Neofetch-.git

# Go into the directory
cd Neofetch-

# Install Python package from current directory
pip install .
