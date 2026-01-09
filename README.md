# Dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Overview

This repository contains my dotfiles and configuration files, managed using chezmoi for easy synchronization across multiple machines. The configuration supports different machine types (server, personal, work) with conditional settings.

## Features

- **Multi-machine support**: Conditional configuration based on machine type (server/personal/work)
- **Encrypted secrets**: Sensitive data encrypted using [age](https://github.com/FiloSottile/age)
- **Template-based configuration**: Dynamic configuration files using Go templates
- **Version controlled**: All dotfiles tracked in git for easy rollback and history

## Managed Configurations

- **Shell**: zsh configuration with oh-my-zsh
- **Claude Code**: AI-powered development environment settings
- **Secrets**: Encrypted credentials and API keys

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
   - `server`: For server environments
   - `personal`: For personal machines
   - `work`: For work machines

5. Review the changes that will be applied:
   ```bash
   chezmoi diff
   ```

6. Apply the dotfiles:
   ```bash
   chezmoi apply
   ```

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
├── .chezmoi.yaml.tmpl          # Chezmoi configuration template
├── .chezmoiignore              # Files to ignore
├── .chezmoitemplates/          # Reusable template files
│   └── secrets.yaml            # Encrypted secrets template
├── dot_claude/                 # Claude Code configuration
│   └── settings.json.tmpl      # Claude settings template
├── dot_config/                 # Config directory
│   └── encrypted_chezmoi-secrets.yaml.age  # Encrypted secrets
└── dot_zshrc.tmpl              # Zsh configuration template
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
