<p align="center"><b>lingti-code</b> — AI-ready development environment built on Tmux + Neovim + Zsh.<br>One-line install on <b>macOS</b>, <b>Ubuntu</b>, and <b>Docker</b>.</p>

---

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/ruilisi/lingti-code/main/install.sh | bash
```

<details>
<summary><b>Docker</b></summary>

```bash
docker run -it ubuntu:latest
apt update && apt install -y git curl zsh sudo
curl -fsSL https://raw.githubusercontent.com/ruilisi/lingti-code/main/install.sh | bash
```
</details>

<details>
<summary><b>Manual install</b></summary>

```bash
git clone https://github.com/ruilisi/lingti-code.git ~/.lingti
cd ~/.lingti && rake install
```
</details>

### Update

```bash
cd ~/.lingti && git pull --rebase && rake update
```

---

## What's Included

| Category | Details |
|----------|---------|
| **Shell** | ZSH + [Prezto](https://github.com/sorin-ionescu/prezto), 100+ aliases, [fasd](https://github.com/clvv/fasd) navigation, custom prompts |
| **Editor** | Neovim + [SpaceVim](https://spacevim.org/), LSP, snippets, ALE linting, [Copilot](https://github.com/features/copilot) |
| **Multiplexer** | Tmux with vim keybindings, `Ctrl-a` prefix, vim-tmux-navigator |
| **Git** | Sensible defaults, extensive aliases (`ga`, `gc`, `gd`, `gfr`…), commitlint |
| **Tools** | asdf version manager, ctags, IRB/Pry enhancements |
| **AI** | [Claude Code](https://claude.ai/code) CLI config, notification hooks, custom status line |

---

## Project Structure

```
~/.lingti/
├── Rakefile              # Installation orchestrator
├── lib/tasks/            # Modular rake tasks
├── zsh/                  # ZSH config + prezto submodule
├── SpaceVim.d/           # Neovim config (init.toml, autoload/, snippets/)
├── git/                  # Git config
├── tmux/                 # Tmux config
├── claude/               # Claude Code config
├── bin/                  # CLI utilities (lingti command)
└── doc/                  # Documentation
```

---

## Customization

### ZSH

Drop files into `~/.zsh.after/` (loaded after Lingti configs) or `~/.zsh.before/` (loaded before). Platform-specific files use `-darwin.zsh` / `-linux.zsh` suffix.

### Vim Plugins

```bash
lingti vim-add-plugin tpope/vim-surround
```

Or add to `SpaceVim.d/init.toml`:
```toml
[[custom_plugins]]
repo = "tpope/vim-surround"
merged = false
```

### Git

Personal settings in `~/.gitconfig.user`, secrets in `~/.secrets`.

### Tmux

User overrides in `~/.tmux.conf.user`.

---

## Documentation

| Document | Description |
|----------|-------------|
| [docs/ALIASES.md](docs/ALIASES.md) | Shell aliases reference |
| [doc/keymaps.md](doc/keymaps.md) | Keyboard shortcuts (Zsh, Tmux, Vim) |
| [doc/vim/loading.md](doc/vim/loading.md) | How nvim loads |
| [doc/vim/coding.md](doc/vim/coding.md) | Coding features |
| [doc/vim/navigation.md](doc/vim/navigation.md) | Navigation shortcuts |
| [doc/vim/manage_plugins.md](doc/vim/manage_plugins.md) | Plugin management |
| [doc/vim/override.md](doc/vim/override.md) | Vim customization |
| [docs/ECOSYSTEM.md](docs/ECOSYSTEM.md) | Lingti product family |
| [FAQ.md](FAQ.md) | FAQ |

---

## Rake Tasks

```bash
rake -T                  # List all tasks
rake install             # Full install
rake install_prezto      # ZSH/Prezto only
rake install_spacevim    # Neovim/SpaceVim only
rake install_asdf        # Version manager only
rake install_claude      # Claude Code config only

ASK=true rake install    # Interactive mode
DEBUG=true rake install  # Dry run
```

---

## License

[MIT](LICENSE) · [Credits](doc/credits.md) · [Changelog](CHANGELOG.md)
