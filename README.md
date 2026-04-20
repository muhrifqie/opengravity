# OpenCode Antigravity Kit

This repository provides a "one-click" installer to connect [OpenCode](https://opencode.ai) to **Antigravity**, allowing you to use high-end models like Gemini 3 Pro and Claude Opus 4.6 for free using your Google credentials.

## Quick Install

### Windows (PowerShell)
Run this in your PowerShell terminal:
```powershell
irm https://raw.githubusercontent.com/YOUR_USERNAME/opencode-antigravity-kit/main/install.ps1 | iex
```

### macOS / Linux (Bash)
Run this in your terminal:
```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/opencode-antigravity-kit/main/install.sh | bash
```

## Post-Installation

Once the installer finishes:

1.  Run the login command:
    ```bash
    opencode auth login
    ```
2.  Select **Google**.
3.  Choose **OAuth with Google (Antigravity)**.
4.  Complete the login in your browser.

## Using Antigravity Models

Try running a command with one of the new models:

```bash
opencode run "Hello" --model=google/antigravity-claude-opus-4-6-thinking --variant=max
```

### Available Models:
- `antigravity-gemini-3-pro`
- `antigravity-gemini-3-flash`
- `antigravity-claude-sonnet-4-6`
- `antigravity-claude-opus-4-6-thinking`

## License
MIT
