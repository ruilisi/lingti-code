<p align="center"><b>lingti-code</b> is an all-in-one AI-ready development environment platform built on Tmux + Vim/Neovim + Zsh. Supports <b>macOS</b> and <b>Ubuntu</b> one-line installation, as well as <b>Docker</b> instant deployment. Bundles ZSH (Prezto), Neovim (SpaceVim), Tmux, Git, AI coding tools (Claude Code, GitHub Copilot), network acceleration, and 100+ developer utilities into a cohesive system.</p>

<p align="center">
  <b>macOS</b> one-click install via Homebrew &nbsp;|&nbsp; <b>Ubuntu</b> one-click install via apt &nbsp;|&nbsp; <b>Docker</b> instant deployment
</p>

---

## Lingti Product Ecosystem

**lingti-code** is part of the Lingti product family by [Suzhou Ruilisi Network Technology Co., Ltd.](https://lingti.com), which has served nearly 10,000 enterprises and holds 22 patents (13 invention) and 100+ software copyrights.

| Product | Description |
|---------|-------------|
| [lingti-code](https://cli.lingti.com/code) | AI-enhanced development environment for global developers — **this project** (open-source) |
| [Lingti Game Booster](https://game.lingti.com) | Game network accelerator — reached **#13 on App Store China Top Grossing** (2020) |
| [Lingti Router](https://router.lingti.com) | World's first router relay software with lightweight remote management, combining game acceleration and IoT control |
| [Xiemala](https://xiemala.com) | AI-assisted online collaboration and low-code form platform for enterprise productivity |
| [Lingti Esports](https://hy.lingti.com) | Leading mind-sports tournament platform — real-time scoring, smart seating, QR check-in, 10K+ concurrent players, **free to use** |
| Lingti Duplicate Dealer | World's first portable AIOT card-dealing device with AI vision and hand-equity balancing, supporting 100-unit cluster sync |

---

## Table of Contents

- [What's Included](#whats-included)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Documentation](#documentation)
- [Tool Configurations](#tool-configurations)
- [Customization](#customization)
- [AI Integration (Claude)](#ai-integration-claude)
- [Development & Contributing](#development--contributing)

---

## What's Included

### Shell Environment
- **ZSH** with [Prezto](https://github.com/sorin-ionescu/prezto) framework
- 100+ shell aliases and functions (git, docker, k8s, etc.)
- [fasd](https://github.com/clvv/fasd) for quick directory navigation
- Custom prompt themes

### Editor
- **Neovim** with [SpaceVim](https://spacevim.org/) distribution
- Language layers: TypeScript, Go, Ruby, Python, Rust, C
- LSP integration with auto-completion
- Snippets, linting (ALE), and formatting
- [GitHub Copilot](https://github.com/features/copilot) integration

### Terminal Multiplexer
- **Tmux** with vim-style keybindings
- Powerful status bar
- Session management
- vim-tmux-navigator for seamless pane switching

### Version Control
- **Git** configuration with sensible defaults
- Extensive git aliases (`ga`, `gc`, `gd`, `gfr`, etc.)
- Commitlint for conventional commits

### Development Tools
- **asdf** version manager (Node.js, Ruby, Python, etc.)
- **ctags** configuration
- **IRB/Pry** Ruby REPL enhancements

### AI Assistant
- **Claude Code** CLI configuration
- Project-aware AI assistance via CLAUDE.md

---

## Quick Start

### Requirements

```bash
# macOS
brew install zsh tmux neovim ag

# Linux
sudo apt install zsh tmux neovim silversearcher-ag

# Set zsh as default shell
chsh -s $(which zsh)

# Install Python support for Neovim
python3 -m pip install --user --upgrade pynvim
```

### Installation

```bash
# One-line install (macOS or Ubuntu)
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ruilisi/lingti-code/master/install.sh)"

# Or clone and install manually
git clone https://github.com/ruilisi/lingti-code.git ~/.lingti
cd ~/.lingti
rake install
```

The installer **automatically detects your platform** and uses Homebrew (macOS) or apt (Ubuntu/Debian) to install all dependencies. No manual configuration needed.

#### Docker Instant Deployment

```bash
docker run -it ubuntu:latest
apt update && apt install -y git curl zsh sudo
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ruilisi/lingti-code/master/install.sh)"
```

Ideal for cloud development, CI/CD pipelines, or spinning up a temporary full-featured dev environment in seconds.

### Updating

```bash
cd ~/.lingti
git pull --rebase
rake update
```

---

## Project Structure

```
~/.lingti/
├── Rakefile              # Main installation orchestrator
├── lib/
│   ├── helpers.rb        # Shared Ruby utilities
│   └── tasks/            # Modular rake tasks
├── zsh/                  # ZSH configuration files
│   ├── 0_path.zsh        # PATH setup (loaded first)
│   ├── aliases.zsh       # Shell aliases
│   ├── files.zsh         # File operation functions
│   └── prezto-override/  # Prezto customizations
├── SpaceVim.d/           # SpaceVim user configuration
│   ├── init.toml         # Main config with layers
│   ├── autoload/         # Custom vim functions
│   └── snippets/         # Code snippets
├── git/                  # Git configuration
├── tmux/                 # Tmux configuration
├── claude/               # Claude Code CLI config
├── bin/                  # Executable utilities (lingti command)
└── doc/                  # Documentation
```

### Installation Creates

| Location | Description |
|----------|-------------|
| `~/.lingti` | Main repository |
| `~/.SpaceVim` | SpaceVim framework |
| `~/.SpaceVim.d` | Symlink to `~/.lingti/SpaceVim.d` |
| `~/.zprezto` | Prezto framework |
| `~/.zshrc` | Symlink to Lingti zsh config |
| `~/.tmux.conf` | Symlink to Lingti tmux config |
| `~/.gitconfig` | Symlink to Lingti git config |
| `~/.claude` | Claude Code configuration |

---

## Documentation

| Document | Description |
|----------|-------------|
| [doc/keymaps.md](doc/keymaps.md) | All keyboard shortcuts (Zsh, Tmux, Vim) |
| [doc/shortcuts.md](doc/shortcuts.md) | Shell commands and aliases |
| [doc/vim-basic.md](doc/vim-basic.md) | Basic vim commands |
| [doc/zsh/themes.md](doc/zsh/themes.md) | Custom ZSH theme guide |
| [CLAUDE.md](CLAUDE.md) | AI assistant project context |
| [FAQ.md](FAQ.md) | Frequently asked questions |

### Vim Documentation

| Document | Description |
|----------|-------------|
| [doc/vim/loading.md](doc/vim/loading.md) | **How nvim loads** (startup phases, hooks, config order) |
| [doc/vim/coding.md](doc/vim/coding.md) | Coding features |
| [doc/vim/navigation.md](doc/vim/navigation.md) | Navigation shortcuts |
| [doc/vim/textobjects.md](doc/vim/textobjects.md) | Text objects |
| [doc/vim/manage_plugins.md](doc/vim/manage_plugins.md) | Plugin management |
| [doc/vim/override.md](doc/vim/override.md) | Customization guide |

---

## Tool Configurations

### ZSH & Prezto

Lingti uses [Prezto](https://github.com/sorin-ionescu/prezto) as the ZSH framework, bundled as a git submodule.

**Installation Process (`rake install_prezto`):**
1. Git submodule init pulls prezto into `~/.lingti/zsh/prezto/`
2. Symlinks `~/.zprezto` → `~/.lingti/zsh/prezto/`
3. Symlinks runcoms (`~/.zshrc`, `~/.zshenv`, etc.) from prezto
4. Overrides `~/.zpreztorc` with Lingti's custom config (enables extra modules)
5. Creates user customization directories

**Resulting Symlinks:**
| Target | Links To |
|--------|----------|
| `~/.zprezto` | `~/.lingti/zsh/prezto/` |
| `~/.zpreztorc` | `~/.lingti/zsh/prezto-override/zpreztorc` |
| `~/.zshrc` | `~/.lingti/zsh/prezto/runcoms/zshrc` |

**Load Order:** `0_path.zsh` → `0000_before.zsh` → (alphabetical) → `zzzz_after.zsh`

**User Customization:**
- `~/.zsh.before/` - Loaded before Lingti configs
- `~/.zsh.after/` - Loaded after Lingti configs
- `~/.zsh.prompts/` - Custom prompt themes

**Platform-Specific:** Use `-darwin.zsh` or `-linux.zsh` suffix.

### SpaceVim

**Configuration:** `~/.SpaceVim.d/init.toml`

```toml
# Enable language layers
[[layers]]
name = "lang#go"

[[layers]]
name = "lang#typescript"

# Custom plugins
[[custom_plugins]]
repo = "github/copilot.vim"
merged = false
```

**Key Prefixes:**
- `SPC` (Space) - SpaceVim leader
- `,` - Local leader / Lingti utilities
- `\` - Vim leader

### Git

Store personal settings in `~/.gitconfig.user`:

```ini
[user]
    name = Your Name
    email = your@email.com
```

Environment variables go in `~/.secrets`.

### Tmux

**Prefix:** `Ctrl-a` (changed from default `Ctrl-b`)

**User Overrides:** `~/.tmux.conf.user`

See [doc/keymaps.md#2-tmux](doc/keymaps.md#2-tmux) for all shortcuts.

---

## Customization

### Adding Custom ZSH Config

```bash
# ~/.zsh.after/my-aliases.zsh
alias myproject="cd ~/projects/myproject"
```

### Adding Vim Plugins

```bash
# Via command line
lingti vim-add-plugin tpope/vim-surround

# Or edit SpaceVim.d/init.toml
[[custom_plugins]]
repo = "tpope/vim-surround"
merged = false
```

### Overriding Vim Settings

Edit `~/.SpaceVim.d/autoload/config.vim`:

```vim
function! config#before() abort
  " Settings before SpaceVim loads
endfunction

function! config#after() abort
  " Settings after SpaceVim loads
  set relativenumber
endfunction
```

---

## AI Integration (Claude)

Lingti includes configuration for [Claude Code](https://claude.ai/code), Anthropic's AI coding assistant.

### Setup

```bash
rake install_claude
```

This creates `~/.claude/` with:
- `CLAUDE.md` - Global instructions for Claude across all projects
- `settings.json` - Claude Code settings
- `scripts/` - Custom scripts (symlinked)

### Features

#### Notification Sound
Plays a sound when Claude needs your attention (e.g., waiting for input, task complete):
```json
"hooks": {
  "Notification": [{ "hooks": [{ "type": "command", "command": "afplay /System/Library/Sounds/Glass.aiff" }] }]
}
```

#### Custom Status Line
Shows current directory, model, and token usage in the status bar:
```
lingti | Claude Sonnet 4 | Tokens: 12,847/200,000 (93.6% remaining)
```

The status line script (`scripts/statusline.sh`) displays:
- Current directory name
- Active model
- Output style (if set)
- Token usage and remaining percentage

#### LSP Plugins
Pre-configured language server plugins:
- `basedpyright` - Python
- `gopls` - Go

### Project Context

The root `CLAUDE.md` provides Claude with project overview, architecture, commands, and conventions. Claude Code automatically reads this file to understand the project context.

### Customizing

Edit `~/.lingti/claude/settings.json` for global settings, or create project-specific `.claude/` directories.

---

## Development & Contributing

### Rake Tasks

```bash
rake -T                  # List all tasks
rake install_prezto      # ZSH/Prezto
rake install_spacevim    # Neovim/SpaceVim
rake install_asdf        # Version manager
rake install_claude      # Claude Code config

ASK=true rake install    # Interactive mode
DEBUG=true rake install  # Dry run
```

### Project Conventions

1. **Modular Tasks:** Each component in `lib/tasks/`
2. **Helpers:** Shared utilities in `lib/helpers.rb`
3. **Symlinks:** Configs linked to `~/` with `.` prefix
4. **Backups:** Existing files saved as `~/.filename.backup`
5. **Commits:** Conventional commits via commitlint

### Testing

```bash
# Test on fresh Ubuntu system (see Docker Instant Deployment above)
ASK=true rake install    # Interactive mode
DEBUG=true rake install  # Dry run
```

---

## Additional Resources

- [CHANGELOG.md](CHANGELOG.md) - Version history
- [doc/credits.md](doc/credits.md) - Acknowledgments
- [LICENSE](LICENSE) - MIT License
