#!/bin/bash
# install.sh - OpenCode Antigravity Kit Installer
# Supports macOS and Linux

set -e

echo "--- OpenCode Antigravity Kit Installer ---"

# 1. Check for Node.js / npm
if ! command -v npm &> /dev/null; then
    echo "Error: npm is not installed. Please install Node.js first."
    exit 1
fi

# 2. Install/Update OpenCode
echo "Checking OpenCode installation..."
npm install -g opencode-ai
echo "OpenCode is ready."

# 3. Install Antigravity Plugin
echo "Installing opencode-antigravity-auth plugin..."
opencode plugin opencode-antigravity-auth -g
echo "Plugin installed."

# 4. Setup Configuration
CONFIG_DIR="$HOME/.config/opencode"
mkdir -p "$CONFIG_DIR"

CONFIG_FILE="$CONFIG_DIR/opencode.json"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
TEMPLATE_FILE="$SCRIPT_DIR/templates/opencode.json"

if [ -f "$TEMPLATE_FILE" ]; then
    echo "Configuring models in $CONFIG_FILE..."
    cp "$TEMPLATE_FILE" "$CONFIG_FILE"
    echo "Configuration complete."
else
    echo "Warning: Template file not found. Skipping auto-config."
fi

echo -e "\n--- Installation Finished ---"
echo "Next Step: Run 'opencode auth login', select 'Google', then 'OAuth with Google (Antigravity)'."
echo "Then try: opencode run 'Hello' --model=google/antigravity-claude-opus-4-6-thinking"
