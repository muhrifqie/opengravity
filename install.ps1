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
npm install -g opencode-ai
Write-Host "OpenCode is ready." -ForegroundColor Green

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
$templateFile = Join-Path $PSScriptRoot "templates\opencode.json"

if (Test-Path $templateFile) {
    Write-Host "Configuring models in $configFile..."
    Copy-Item $templateFile $configFile -Force
    Write-Host "Configuration complete." -ForegroundColor Green
} else {
    Write-Warning "Template file not found. Skipping auto-config."
}

Write-Host "`n--- Installation Finished ---" -ForegroundColor Cyan
Write-Host "Next Step: Run 'opencode auth login', select 'Google', then 'OAuth with Google (Antigravity)'." -ForegroundColor Yellow
Write-Host "Then try: opencode run 'Hello' --model=google/antigravity-claude-opus-4-6-thinking" -ForegroundColor White
