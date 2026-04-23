<p align="center"><b>lingti-code</b> — AI-ready development environment built on Tmux + Neovim + Zsh.<br>One-line install on <b>macOS</b>, <b>Ubuntu</b>, and <b>Docker</b>.</p>

---

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/ruilisi/lingti-code/main/install.sh | bash
```

On macOS, the installer now attempts to install `JetBrainsMono Nerd Font` via Homebrew so `agnoster` and other glyph-heavy prompts render correctly.

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
| **AI** | [Claude Code](https://claude.ai/code) CLI config, notification hooks, custom status line, `ralphal` autonomous agent loop |

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
└── docs/                 # Documentation
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

### Yolo Mode (`yolo`)

`yolo` launches Claude Code with `--dangerously-skip-permissions`, skipping all permission prompts.

```bash
yolo                          # interactive session
yolo -c                       # continue last conversation
yolo -p "explain this repo"   # one-shot prompt
yolo --model opus             # use a specific model
yolo -p "summarize README" > out.txt  # pipe output
```

---

### AI Agent Loop (ralphal)

`ralphal` runs [Ralph](https://github.com/snarktank/ralph) with Claude Code — an autonomous loop that implements tasks from a `prd.json` file, committing after each iteration until all stories are done or the iteration limit is reached.

```bash
ralphal        # run up to 10 iterations with Claude Code
ralphal 5      # run up to 5 iterations
```

**Project setup** (run from your project directory):

1. Create `prd.json` with your tasks (see [Ralph docs](https://github.com/snarktank/ralph))
2. Create `CLAUDE.md` with instructions for the agent
3. Run `ralphal`

State files (`progress.txt`, `.last-branch`, `archive/`) are written to the current working directory. Ralph detects branch changes and archives previous run artifacts automatically.

---

### Git

Personal settings in `~/.gitconfig.user`, secrets in `~/.secrets`.

### Tmux

User overrides in `~/.tmux.conf.user`.

---

## Documentation

| Document | Description |
|----------|-------------|
| [docs/ALIASES.md](docs/ALIASES.md) | Shell aliases reference |
| [docs/vim-keymaps.md](docs/vim-keymaps.md) | Keyboard shortcuts (Zsh, Tmux, Vim) |
| [docs/vim/loading.md](docs/vim/loading.md) | How nvim loads |
| [docs/vim/coding.md](docs/vim/coding.md) | Coding features |
| [docs/vim/navigation.md](docs/vim/navigation.md) | Navigation shortcuts |
| [docs/vim/manage_plugins.md](docs/vim/manage_plugins.md) | Plugin management |
| [docs/vim/override.md](docs/vim/override.md) | Vim customization |
| [docs/vim/lsp.md](docs/vim/lsp.md) | LSP setup, clients & keymaps |
| [docs/bin-commands.md](docs/bin-commands.md) | CLI utilities in `bin/` |
| [docs/ECOSYSTEM.md](docs/ECOSYSTEM.md) | Lingti product family |
| [FAQ.md](FAQ.md) | FAQ |

---

## Rake Tasks

```bash
rake -T                  # List all tasks
rake install             # Full install
rake install_fonts       # Terminal fonts for prompt glyphs
rake install_prezto      # ZSH/Prezto only
rake install_spacevim    # Neovim/SpaceVim only
rake install_asdf        # Version manager only
rake install_claude      # Claude Code config only

ASK=true rake install    # Interactive mode
DEBUG=true rake install  # Dry run
```

---

## License

[MIT](LICENSE) · [Credits](docs/credits.md) · [Changelog](CHANGELOG.md)
