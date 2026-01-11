# Dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Overview

This repository contains my dotfiles and configuration files, managed using chezmoi for easy synchronization across multiple machines. The configuration supports different machine types (server, personal, work) with conditional settings.

The setup features a modern development environment with GPU-accelerated terminal, multiplexer, enhanced shell, and a curated collection of modern CLI tools.

## Features

- **Multi-machine support**: Conditional configuration based on machine type (server/personal/work)
- **Encrypted secrets**: Sensitive data encrypted using [age](https://github.com/FiloSottile/age)
- **Template-based configuration**: Dynamic configuration files using Go templates
- **Automated setup**: One-command installation of all tools and configurations
- **Modern toolchain**: Rust-based CLI tools for enhanced performance (eza, bat, fd, ripgrep, etc.)
- **Unified theme**: Catppuccin color scheme across all applications
- **Version controlled**: All dotfiles tracked in git for easy rollback and history

## Tool Stack

### Terminal & Shell
- **Terminal**: [Ghostty](https://ghostty.org/) - Modern GPU-accelerated terminal emulator
- **Shell (macOS)**: [Fish](https://fishshell.com/) - Friendly interactive shell with modern features
- **Shell (Linux)**: [Zsh](https://www.zsh.org/) with [Oh My Zsh](https://ohmyz.sh/) framework
- **Multiplexer**: [Zellij](https://zellij.dev/) - Terminal workspace with layouts
- **Prompt**: [Starship](https://starship.rs/) - Fast, customizable cross-shell prompt

### Modern CLI Tools
- **File listing**: [eza](https://github.com/eza-community/eza) - Modern replacement for ls
- **File search**: [fd](https://github.com/sharkdp/fd) - Fast alternative to find
- **Content search**: [ripgrep](https://github.com/BurntSushi/ripgrep) - Fast grep alternative
- **File viewer**: [bat](https://github.com/sharkdp/bat) - Cat with syntax highlighting
- **Directory jump**: [zoxide](https://github.com/ajeetdsouza/zoxide) - Smarter cd command
- **Fuzzy finder**: [fzf](https://github.com/junegunn/fzf) - Command-line fuzzy finder
- **Environment**: [direnv](https://direnv.net/) - Directory-specific environment variables
- **Git UI**: [lazygit](https://github.com/jesseduffield/lazygit) - Terminal UI for git

### Fish Shell Plugins (macOS)
- [Fisher](https://github.com/jorgebucaran/fisher) - Plugin manager
- [fzf.fish](https://github.com/PatrickF1/fzf.fish) - Enhanced fzf integration
- [autopair.fish](https://github.com/jorgebucaran/autopair.fish) - Auto-close brackets and quotes
- [puffer-fish](https://github.com/nickeb96/puffer-fish) - Text expansion abbreviations
- [sponge](https://github.com/meaningful-ooo/sponge) - Clean up failed commands from history

### Development Tools
- **AI Assistant**: [Claude Code](https://claude.ai/code) - AI-powered development environment with AWS Bedrock backend
- **Font**: JetBrains Mono Nerd Font - Patched font with programming ligatures and icons

## Managed Configurations

### Shell Configuration
- **Zsh** (Linux/Server): Oh My Zsh with custom theme and plugins
- **Fish** (macOS): Modern shell with abbreviations, custom theme, and plugins

### Terminal & Multiplexer
- **Ghostty**: GPU-accelerated terminal with Catppuccin theme
- **Zellij**: Terminal multiplexer with custom layouts and keybindings
- **Starship**: Cross-shell prompt with git integration

### Development
- **Claude Code**: AWS Bedrock integration with model configuration
- **Git**: lazygit for visual git management

### Secrets
- Encrypted credentials and API keys using age encryption

## Prerequisites

- [chezmoi](https://www.chezmoi.io/install/)
- [age](https://github.com/FiloSottile/age) (for encrypted secrets)

## Installation

### First-time setup on a new machine

1. Install chezmoi:
   ```bash
   sh -c "$(curl -fsLS get.chezmoi.io)"
   ```

2. Set up the age encryption key:
   ```bash
   # Create the chezmoi config directory if it doesn't exist
   mkdir -p ~/.config/chezmoi

   # Move or copy your age encryption key to the expected location
   # Replace /path/to/your/key.txt with your actual key location
   mv /path/to/your/key.txt ~/.config/chezmoi/key.txt

   # Secure the key file
   chmod 600 ~/.config/chezmoi/key.txt
   ```

3. Initialize chezmoi with this repository:
   ```bash
   chezmoi init https://github.com/zhaobaiyu/dotfiles.git
   ```

4. During initialization, you'll be prompted to select your machine type:
   - `server`: For server environments (uses Zsh)
   - `personal`: For personal machines (uses Fish on macOS, Zsh on Linux)
   - `work`: For work machines with company-specific configurations

5. Review the changes that will be applied:
   ```bash
   chezmoi diff
   ```

6. Apply the dotfiles:
   ```bash
   chezmoi apply
   ```

### Platform-specific notes

#### macOS
The setup script will automatically:
- Install Homebrew if not present
- Install all tools via Homebrew (Ghostty, Fish, Zellij, etc.)
- Install Fisher and all Fish plugins
- Set Fish as the default shell

#### Linux (Debian/Ubuntu)
The setup script will automatically:
- Install Zsh, Git, and Curl
- Install Oh My Zsh
- Install Zsh plugins (autosuggestions, syntax highlighting)

Note: On Linux, you'll need to manually install modern CLI tools (eza, bat, fd, etc.) or use alternative package managers like [Homebrew for Linux](https://docs.brew.sh/Homebrew-on-Linux).

### Updating existing dotfiles

```bash
chezmoi update
```

## Configuration

### Machine Type

The configuration uses the `machine_type` variable to conditionally apply settings. This is set during initial setup and stored in `~/.config/chezmoi/chezmoi.yaml`.

**Work machines** get:
- AWS profile configuration for work access
- Telemetry disabled for Claude Code

**Personal/Server machines** get:
- AWS bearer token from encrypted secrets
- Standard telemetry settings

### Encryption

Sensitive data is encrypted using age encryption. The encryption key is stored in `~/.config/chezmoi/key.txt`.

To edit encrypted files:
```bash
chezmoi edit ~/.config/chezmoi-secrets.yaml
```

### Templates

Configuration files use Go templates for dynamic content:
- `dot_zshrc.tmpl`: Shell configuration
- `dot_claude/settings.json.tmpl`: Claude Code settings
- `.chezmoi.yaml.tmpl`: Chezmoi configuration

## Usage

### Edit dotfiles

```bash
chezmoi edit ~/.zshrc
```

### Add a new dotfile

```bash
chezmoi add ~/.gitconfig
```

### View differences

```bash
chezmoi diff
```

### Apply changes

```bash
chezmoi apply
```

### Update from repository

```bash
chezmoi update
```

## Directory Structure

```
.
├── .chezmoi.yaml.tmpl                      # Chezmoi configuration template
├── .chezmoiignore                          # Files to ignore based on OS
├── .chezmoitemplates/                      # Reusable template files
│   └── secrets.yaml                        # Encrypted secrets template
├── dot_claude/                             # Claude Code configuration
│   └── settings.json.tmpl                  # Claude settings with Bedrock config
├── dot_config/                             # Config directory (~/.config)
│   ├── encrypted_chezmoi-secrets.yaml.age  # Encrypted secrets (age format)
│   ├── ghostty/                            # Ghostty terminal config
│   │   └── config                          # Theme and appearance settings
│   ├── private_fish/                       # Fish shell config (macOS)
│   │   ├── config.fish                     # Main Fish configuration
│   │   ├── fish_plugins                    # Fisher plugin list
│   │   └── conf.d/                         # Configuration fragments
│   │       ├── 00_env.fish                 # Environment variables
│   │       ├── abbrs.fish                  # Command abbreviations
│   │       └── theme.fish                  # Catppuccin color theme
│   ├── starship.toml                       # Starship prompt config
│   └── zellij/                             # Zellij multiplexer config
│       ├── config.kdl                      # Main configuration
│       └── layouts/                        # Custom layouts
│           └── dev.kdl                     # Development workspace layout
├── dot_zshrc.tmpl                          # Zsh configuration (Linux)
├── empty_dot_hushlogin                     # Suppress login message
├── run_onchange_before_install_mac.sh      # macOS tool installation script
├── run_onchange_after_configure_mac.sh.tmpl # Fish plugin setup script
├── run_onchange_before_install_debian.sh   # Debian/Ubuntu setup script
└── README.md                               # This file
```

## Customization

### Adding machine-specific configuration

Use conditional blocks in templates:

```go
{{- if eq .machine_type "work" }}
# Work-specific configuration
{{- else }}
# Personal/server configuration
{{- end }}
```

### Adding new encrypted secrets

1. Edit the secrets file:
   ```bash
   chezmoi edit ~/.config/chezmoi-secrets.yaml
   ```

2. Access secrets in templates:
   ```go
   {{- $secrets := includeTemplate "secrets.yaml" . | fromYaml -}}
   {{ $secrets.your_secret_key }}
   ```

## Contributing

This is a personal dotfiles repository, but feel free to use it as inspiration for your own setup.

## License

MIT
