# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Lingti (Yet Another Dotfiles Repo) is a dotfiles management framework for macOS/Linux. It bundles configurations for ZSH (Prezto), Neovim (SpaceVim), Tmux, Git, and development tools.

## Commands

### Installation & Updates

```bash
# Full installation (or update existing)
rake install

# Update after git pull
cd ~/.lingti && git pull --rebase && rake update

# Individual components
rake link_files          # Symlink configs to ~/
rake install_prezto      # ZSH/Prezto setup
rake install_spacevim    # Neovim setup
rake install_asdf        # Version manager setup
```

### Vim Plugin Management

```bash
lingti vim-add-plugin <github-user/repo>
lingti vim-delete-plugin <plugin-name>
lingti vim-list-plugin
lingti init-plugins        # Initialize all plugins
lingti update-plugins      # Update all plugins
```

### Environment Variables

```bash
ASK=true rake install    # Prompt for each section
SKIP_SUBMODULES=true     # Skip git submodule init
DEBUG=true               # Dry run (no execution)
```

## Architecture

### Directory Structure

- `Rakefile` - Main installation orchestrator (Ruby)
- `zsh/` - ZSH configuration with Prezto framework
- `SpaceVim.d/` - Neovim/SpaceVim configuration (init.toml, autoload/, snippets/)
- `git/` - Git config and aliases (gitconfig, gitignore)
- `tmux/` - Tmux configuration (base + local override)
- `bin/` - Executable utilities including `lingti` command

### ZSH Load Order

Files are loaded by filename prefix: `0_path.zsh` → `0000_before.zsh` → alphabetical → `zzzz_after.zsh`

User customization directories (created on install):
- `~/.zsh.before/` - Loaded before Lingti configs
- `~/.zsh.after/` - Loaded after Lingti configs
- `~/.zsh.prompts/` - Custom prompt themes

Platform-specific files use `-darwin.zsh` or `-linux.zsh` suffix.

### Symlink Strategy

Configs are symlinked to `~/` with `.` prefix. Existing files backed up as `~/.filename.backup`. The Rakefile's `link_file()` function is idempotent - safe to re-run.

### Configuration Separation Pattern

Each tool uses a split config approach for customization:
- **Git**: `git/gitconfig` includes `~/.gitconfig.user` for personal settings
- **Tmux**: `tmux.conf` (base) + `tmux.conf.local` (user overrides)
- **Prezto**: `zsh/prezto-override/` to customize without modifying submodule

### SpaceVim Structure

Installation creates two directories in home:
- `~/.SpaceVim` - Cloned from https://github.com/lingti/SpaceVim.git (the framework)
- `~/.SpaceVim.d` - Symlink to `SpaceVim.d/` in this repo (user configuration)

Configuration:
- `SpaceVim.d/init.toml` - Main config with `[[layers]]` for languages
- Language layers: javascript, typescript, go, ruby, python, rust, c
- Linter: ALE engine with auto-fix on save
- Custom plugins via `[[custom_plugins]]` section
- Bootstrap hooks: `bootstrap_before` and `bootstrap_after` functions

## Key Patterns

### Rakefile Helpers

```ruby
macos?        # Platform detection
linux?
link_file()   # Idempotent symlink with backup
```

### Prezto as Submodule

The only git submodule is `zsh/prezto`. Customizations go in `prezto-override/` to allow upstream updates while maintaining local config.

## Git Hooks

Commitlint enforces conventional commits via Husky. Run `yarn install` to enable hooks.
