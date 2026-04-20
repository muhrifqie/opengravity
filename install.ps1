# install.ps1 - OpenCode Antigravity Kit Installer
# Supports Windows

$ErrorActionPreference = "Stop"

Write-Host "--- OpenCode Antigravity Kit Installer ---" -ForegroundColor Cyan

# 1. Check for Node.js / npm
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Error "npm is not installed. Please install Node.js first: https://nodejs.org/"
    exit 1
}

# 2. Install/Update OpenCode
Write-Host "Checking OpenCode installation..."
# Use & to ensure we can check $LASTEXITCODE
& npm install -g opencode-ai
if ($LASTEXITCODE -ne 0) {
    Write-Warning "OpenCode update failed (Exit Code: $LASTEXITCODE). If OpenCode is currently running, please close it and try again."
} else {
    Write-Host "OpenCode is ready." -ForegroundColor Green
}

# 3. Install Antigravity Plugin
Write-Host "Installing opencode-antigravity-auth plugin..."
opencode plugin opencode-antigravity-auth -g
Write-Host "Plugin installed." -ForegroundColor Green

# 4. Setup Configuration
$configDir = Join-Path $env:USERPROFILE ".config\opencode"
if (-not (Test-Path $configDir)) {
    New-Item -ItemType Directory -Path $configDir -Force
}

$configFile = Join-Path $configDir "opencode.json"

# Resolve template file path safely
$templateFile = ""
if ($PSScriptRoot) {
    $templateFile = Join-Path $PSScriptRoot "templates\opencode.json"
}

if ($templateFile -and (Test-Path $templateFile)) {
    Write-Host "Configuring models in $configFile (from local template)..."
    Copy-Item $templateFile $configFile -Force
    Write-Host "Configuration complete." -ForegroundColor Green
} else {
    # Fallback for remote installation: Embedded config
    Write-Host "Local template not found. Applying default Antigravity configuration..."
    $configContent = @'
{
  "$schema": "https://opencode.ai/config.json",
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
'@
    $configContent | Set-Content $configFile -Encoding UTF8
    Write-Host "Configuration complete (embedded)." -ForegroundColor Green
}

Write-Host "`n--- Installation Finished ---" -ForegroundColor Cyan
Write-Host "Next Step: Run 'opencode auth login', select 'Google', then 'OAuth with Google (Antigravity)'." -ForegroundColor Yellow
Write-Host "Then try: opencode run 'Hello' --model=google/antigravity-claude-opus-4-6-thinking" -ForegroundColor White
