#!/bin/bash
set -eufo pipefail

# Exit if not Debian-like Linux (matching .chezmoiignore logic)
[[ "$(uname)" != "Linux" ]] && exit 0
[ -f /etc/os-release ] && . /etc/os-release || exit 0
[[ "$ID" =~ ^(debian|ubuntu)$ || "${ID_LIKE:-}" =~ debian|ubuntu ]] || exit 0

echo "🐧 Detected Debian-like OS. Starting apt install..."

# Define installation paths
OMZ_DIR="$HOME/.oh-my-zsh"
ZSH_CUSTOM="$OMZ_DIR/custom"

# 0. Pre-flight: Ensure zsh, git, and curl are installed
# This is crucial for new Ubuntu/Debian instances without these tools.
if ! command -v zsh >/dev/null 2>&1; then
  echo "🚀 Zsh not found. Installing dependencies..."
  if [ -x "$(command -v apt-get)" ]; then
    # Debian-like
    sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y zsh git curl
  else
    echo "❌ Package manager not found (apt-get). Please install zsh manually."
    exit 1
  fi
fi

# 1. Check and install Oh My Zsh
if [ ! -d "$OMZ_DIR" ]; then
  echo "🚀 Oh My Zsh not found. Installing..."
  # --unattended: Keeps the installer silent and prevents it from starting zsh immediately,
  # which would block the chezmoi script execution.
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "✅ Oh My Zsh is already installed."
fi

# 2. Install zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "🚀 Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
  echo "✅ zsh-autosuggestions is already installed."
fi

# 3. Install zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "🚀 Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
  echo "✅ zsh-syntax-highlighting is already installed."
fi

# 4. (Optional) Change default shell to Zsh
# Note: This usually requires a password and might block the automation process.
# It is recommended to run this manually or configure passwordless sudo if strictly needed.
# if [ "$SHELL" != "$(which zsh)" ]; then
#   echo "Changing default shell to zsh..."
#   chsh -s "$(which zsh)"
# fi