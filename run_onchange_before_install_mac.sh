#!/bin/bash
set -eufo pipefail

# Exit if not macOS (matching .chezmoiignore logic)
[[ "$(uname)" != "Darwin" ]] && exit 0

echo "🍎 Detected macOS. Starting setup..."

if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Load Homebrew into the current shell session immediately
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "Installing tools with homebrew..."

# Install tools
brew bundle --file=/dev/stdin <<EOF
brew "fish"
brew "fzf"
brew "zoxide"
brew "bat"
brew "eza"
brew "fd"
brew "ripgrep"
brew "starship"
brew "zellij"
brew "direnv"
brew "lazygit"
brew "uv"
brew "gh"
brew "git-delta"
cask "ghostty"
cask "font-jetbrains-mono-nerd-font"
cask "font-lxgw-wenkai"
EOF

echo "Brew installation complete."

echo "🐠 Configuring Fish as default shell..."
FISH_PATH="$(brew --prefix)/bin/fish"

if ! grep -q "$FISH_PATH" /etc/shells; then
  echo "Adding Fish to /etc/shells..."
  echo "$FISH_PATH" | sudo tee -a /etc/shells
fi

CURRENT_SHELL=$(dscl . -read /Users/"$USER" UserShell | awk '{print $2}')

if [ "$CURRENT_SHELL" != "$FISH_PATH" ]; then
  echo "Changing default shell to Fish..."
  chsh -s "$FISH_PATH"
  echo "✅ Shell changed to Fish. Please restart your terminal."
else
  echo "✅ Fish is already the default shell."
fi

echo "🐍 Configuring global python..."
GLOBAL_PYTHON_DIR="$HOME/.global-python"
if [ ! -d "$GLOBAL_PYTHON_DIR" ]; then
  echo "Global python not found. Installing..."
  uv python install 3.12
  uv venv ~/.global-python --python 3.12
  uv pip install pip pandas
else
  echo "✅ Global python is already installed."
fi

# Install Claude Code
if ! command -v claude &> /dev/null; then
  echo "Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash
else
  echo "✅ Claude Code is already installed."
fi

# Install Bun
if ! command -v bun &> /dev/null; then
  echo "Installing Bun..."
  curl -fsSL https://bun.sh/install | bash
else
  echo "✅ Bun is already installed."
fi
