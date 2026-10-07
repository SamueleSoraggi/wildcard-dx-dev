#!/usr/bin/env bash
# Run this on your Mac in the directory where you want the project.
# Requires: gh (GitHub CLI) authenticated with your account.
#
#   brew install gh   (if not already installed)
#   gh auth login     (first time)
#
set -euo pipefail

REPO="wildcard-dx-dev"

echo "→ Extracting project files..."
tar -xzf wildcard-dx-dev.tar.gz

echo "→ Initialising git..."
cd "$REPO"
git init
git add .
git commit -m "Initial commit: PVSnesLib project scaffold

SNES homebrew dev setup for the RONT Super Wildcard DX.
Toolchain: PVSnesLib (gcc-65816 + WLA-DX), asar, Mesen.
Transfer: T500 Linux Mint via parallel port + DOSBox-X."

echo "→ Creating GitHub repository..."
gh repo create "$REPO" \
    --public \
    --description "SNES ROM development for the RONT Super Wildcard DX" \
    --push \
    --source .

echo ""
echo "✓ Done! Your repo is live at: https://github.com/\$(gh api user --jq .login)/$REPO"
