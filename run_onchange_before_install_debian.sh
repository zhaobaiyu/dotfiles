#!/bin/bash
set -eufo pipefail

# Exit if not Debian-like Linux (matching .chezmoiignore logic)
[[ "$(uname)" != "Linux" ]] && exit 0
[ -f /etc/os-release ] && . /etc/os-release || exit 0
[[ "$ID" =~ ^(debian|ubuntu)$ || "${ID_LIKE:-}" =~ debian|ubuntu ]] || exit 0

echo "🐧 Detected Debian-like OS. Starting setup..."

# Update package list
echo "Updating package list..."
sudo apt-get update

# Install basic dependencies
echo "Installing basic dependencies..."
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  curl \
  wget \
  git \
  build-essential \
  unzip \
  fontconfig \
  zsh

echo "Installing tools with apt..."

# Install available tools via apt
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  fish \
  fzf \
  bat \
  fd-find \
  ripgrep \
  direnv

# Create symlinks for tools with different names on Debian
if command -v batcat &> /dev/null && ! command -v bat &> /dev/null; then
  mkdir -p ~/.local/bin
  ln -sf /usr/bin/batcat ~/.local/bin/bat
fi

if command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
  mkdir -p ~/.local/bin
  ln -sf /usr/bin/fdfind ~/.local/bin/fd
fi

# Install eza (modern ls replacement)
if ! command -v eza &> /dev/null; then
  echo "Installing eza..."
  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  sudo apt-get update
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y eza
else
  echo "✅ eza is already installed."
fi

# Install zoxide (smart cd replacement)
if ! command -v zoxide &> /dev/null; then
  echo "Installing zoxide..."
  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
else
  echo "✅ zoxide is already installed."
fi

# Install starship (cross-shell prompt)
if ! command -v starship &> /dev/null; then
  echo "Installing starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
else
  echo "✅ starship is already installed."
fi

# Install zellij (terminal multiplexer)
if ! command -v zellij &> /dev/null; then
  echo "Installing zellij..."
  ZELLIJ_VERSION=$(curl -s https://api.github.com/repos/zellij-org/zellij/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
  wget "https://github.com/zellij-org/zellij/releases/download/${ZELLIJ_VERSION}/zellij-x86_64-unknown-linux-musl.tar.gz" -O /tmp/zellij.tar.gz
  tar -xzf /tmp/zellij.tar.gz -C /tmp
  mkdir -p ~/.local/bin
  mv /tmp/zellij ~/.local/bin/
  chmod +x ~/.local/bin/zellij
  rm /tmp/zellij.tar.gz
else
  echo "✅ zellij is already installed."
fi

# Install lazygit
if ! command -v lazygit &> /dev/null; then
  echo "Installing lazygit..."
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  mkdir -p ~/.local/bin
  mv lazygit ~/.local/bin/
  chmod +x ~/.local/bin/lazygit
  rm lazygit.tar.gz
else
  echo "✅ lazygit is already installed."
fi

# Install uv (Python package manager)
if ! command -v uv &> /dev/null; then
  echo "Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
else
  echo "✅ uv is already installed."
fi

# Install JetBrains Mono Nerd Font
FONT_DIR="$HOME/.local/share/fonts"
if [ ! -f "$FONT_DIR/JetBrainsMonoNerdFont-Regular.ttf" ]; then
  echo "Installing JetBrains Mono Nerd Font..."
  mkdir -p "$FONT_DIR"
  FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
  wget "$FONT_URL" -O /tmp/JetBrainsMono.zip
  unzip -o /tmp/JetBrainsMono.zip -d "$FONT_DIR" "*.ttf"
  rm /tmp/JetBrainsMono.zip
  fc-cache -fv
  echo "✅ Font installed successfully."
else
  echo "✅ JetBrains Mono Nerd Font is already installed."
fi

echo "Apt installation complete."

# Configure Zsh with Oh My Zsh
echo "🚀 Configuring Zsh and Oh My Zsh..."

OMZ_DIR="$HOME/.oh-my-zsh"
ZSH_CUSTOM="$OMZ_DIR/custom"

# Install Oh My Zsh
if [ ! -d "$OMZ_DIR" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "✅ Oh My Zsh is already installed."
fi

# Install zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
  echo "✅ zsh-autosuggestions is already installed."
fi

# Install zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
  echo "✅ zsh-syntax-highlighting is already installed."
fi

echo "🐠 Configuring Fish as default shell..."
FISH_PATH="$(which fish)"

if ! grep -q "$FISH_PATH" /etc/shells; then
  echo "Adding Fish to /etc/shells..."
  echo "$FISH_PATH" | sudo tee -a /etc/shells
fi

# Get current user (works in Docker and regular environments)
CURRENT_USER="${USER:-$(whoami)}"
CURRENT_SHELL=$(getent passwd "$CURRENT_USER" | cut -d: -f7)

if [ "$CURRENT_SHELL" != "$FISH_PATH" ]; then
  echo "Changing default shell to Fish..."
  # Try to change shell, but don't fail if it requires password (e.g., in Docker)
  if chsh -s "$FISH_PATH" 2>/dev/null; then
    echo "✅ Shell changed to Fish. Please restart your terminal."
  else
    echo "⚠️  Could not change default shell automatically (may require password)."
    echo "   To change manually, run: chsh -s $FISH_PATH"
  fi
else
  echo "✅ Fish is already the default shell."
fi

echo "🐍 Configuring global python..."
# Ensure uv is in PATH for current session
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

# Verify uv is available
if ! command -v uv &> /dev/null; then
  echo "⚠️  uv command not found in PATH. Skipping Python setup."
  echo "   uv should be installed but may need shell restart."
else
  GLOBAL_PYTHON_DIR="$HOME/.global-python"
  if [ ! -d "$GLOBAL_PYTHON_DIR" ]; then
    echo "Global python not found. Installing..."
    uv python install 3.12
    uv venv ~/.global-python --python 3.12
    # Install packages into the virtual environment
    "$GLOBAL_PYTHON_DIR/bin/pip" install pandas || \
      uv pip install --python "$GLOBAL_PYTHON_DIR/bin/python" pip pandas
  else
    echo "✅ Global python is already installed."
  fi
fi

# Install Claude Code
if ! command -v claude &> /dev/null; then
  echo "Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash
else
  echo "✅ Claude Code is already installed."
fi

# Ensure ~/.local/bin is in PATH
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
  echo ""
  echo "⚠️  Note: Please ensure ~/.local/bin is in your PATH."
  echo "   Add this to your shell config if needed:"
  echo "   export PATH=\"\$HOME/.local/bin:\$PATH\""
fi