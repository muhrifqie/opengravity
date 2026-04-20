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
    echo "Configuring models in $CONFIG_FILE (from local template)..."
    cp "$TEMPLATE_FILE" "$CONFIG_FILE"
    echo "Configuration complete."
else
    # Fallback for remote/piped installation
    echo "Local template not found. Applying default Antigravity configuration..."
    cat > "$CONFIG_FILE" <<EOF
{
  "\$schema": "https://opencode.ai/config.json",
  "plugin": ["opencode-antigravity-auth@latest"],
  "provider": {
    "google": {
      "models": {
        "antigravity-gemini-3-pro": {
          "name": "Gemini 3 Pro (Antigravity)",
          "limit": { "context": 1048576, "output": 65535 },
          "modalities": { "input": ["text", "image", "pdf"], "output": ["text"] },
          "variants": {
            "low": { "thinkingLevel": "low" },
            "high": { "thinkingLevel": "high" }
          }
        },
        "antigravity-gemini-3-flash": {
          "name": "Gemini 3 Flash (Antigravity)",
          "limit": { "context": 1048576, "output": 65536 },
          "modalities": { "input": ["text", "image", "pdf"], "output": ["text"] },
          "variants": {
            "minimal": { "thinkingLevel": "minimal" },
            "low": { "thinkingLevel": "low" },
            "medium": { "thinkingLevel": "medium" },
            "high": { "thinkingLevel": "high" }
          }
        },
        "antigravity-claude-sonnet-4-6": {
          "name": "Claude Sonnet 4.6 (Antigravity)",
          "limit": { "context": 200000, "output": 64000 },
          "modalities": { "input": ["text", "image", "pdf"], "output": ["text"] }
        },
        "antigravity-claude-opus-4-6-thinking": {
          "name": "Claude Opus 4.6 Thinking (Antigravity)",
          "limit": { "context": 200000, "output": 64000 },
          "modalities": { "input": ["text", "image", "pdf"], "output": ["text"] },
          "variants": {
            "low": { "thinkingConfig": { "thinkingBudget": 8192 } },
            "max": { "thinkingConfig": { "thinkingBudget": 32768 } }
          }
        }
      }
    }
  }
}
EOF
    echo "Configuration complete (embedded)."
fi

echo -e "\n--- Installation Finished ---"
echo "Next Step: Run 'opencode auth login', select 'Google', then 'OAuth with Google (Antigravity)'."
echo "Then try: opencode run 'Hello' --model=google/antigravity-claude-opus-4-6-thinking"
