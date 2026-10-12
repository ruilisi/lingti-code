<p align="center"><b>lingti-code</b> — AI-ready development environment built on Tmux + Neovim + Zsh.<br>One-line install on <b>macOS</b>, <b>Ubuntu</b>, and <b>Docker</b>.</p>

<p align="center"><sub>Trusted By：中国人民大学 智慧治理学院 · 睿立思 ecosystem (10,000+ enterprises, 10,000,000+ individual users)</sub></p>

---

灵缇代码（lingti-code）是由「杰客」（[hophacker](https://github.com/hophacker)）自 2017 年 3 月 8 日开始持续维护、并于 2026 年 1 月 29 日正式开源的开发者工具集。正如灵缇犬一样，lingti-code 主打**敏捷、省时、省力与 AI Native**——以 Tmux + Neovim（SpaceVim）+ Zsh（oh-my-zsh）为核心三件套，集成数万个快捷命令，一行 `curl` 命令即可在 macOS、Ubuntu 或 Docker 容器中完成全量安装。在新一波 AI 浪潮中，lingti-code 持续追踪并集成最新的优秀工具与使用方式，与时俱进。

---

## Why Lingti-Code

Nearly a decade in continuous production use (since 2017) across the Suzhou Ruilisi (睿立思) product family — the engineers behind [Lingti Game Booster](https://game.lingti.com) (#13 on App Store China Top Grossing, 2020), [Lingti Router](https://router.lingti.com), [Xiemala](https://xiemala.com), [Lingti Esports](https://hy.lingti.com) and the Lingti AI stack. The same shell/editor/multiplexer configuration ships daily code that serves **10,000+ enterprises** and **10,000,000+ individual users**, and is used in academic research at **中国人民大学 智慧治理学院**.

Open-sourced in January 2026 so anyone can bootstrap the same environment in a single command. The long-term aim is for lingti-code to become the default "new-laptop day-one" setup for developers worldwide — short URL, zero prompts, visibly beautiful terminal within the first minute.

---

## Install

Short URL (recommended):

```bash
curl -fsSL lingti.com/code/install.sh | bash
```

GitHub fallback (same script, direct source):

```bash
curl -fsSL https://raw.githubusercontent.com/ruilisi/lingti-code/main/install.sh | bash
```

The installer is **fully non-interactive** — no y/n prompts, no theme pickers, just a sensible default for everything (`ASK=true rake install` if you want prompts back).

Terminal-first ordering: Homebrew → iTerm2 → JetBrainsMono Nerd Font → Solarized Dark theme → config symlinks → oh-my-zsh → SpaceVim → everything else. You see a pretty terminal before the long tail of dev-tool downloads finishes.

<details>
<summary><b>Docker</b></summary>

```bash
docker run -it ubuntu:latest
apt update && apt install -y git curl zsh sudo
curl -fsSL lingti.com/code/install.sh | bash
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

## What You Get

### Shell

- **ZSH + [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)** with the `agnoster` theme (red when the last command failed, dim when it worked)
- **100+ aliases** covering git, docker, kubernetes, filesystem navigation, networking
- **[fasd](https://github.com/clvv/fasd)** `z`-style directory jumping based on access history
- Per-machine overrides via `~/.zsh.before/` and `~/.zsh.after/` — never edit the shared config

### Editor

- **Neovim + [SpaceVim](https://spacevim.org/)** with native LSP wired to `pyright`, `gopls`, `tsserver`, `sourcekit`, `solargraph`, `rust_analyzer`
- **ALE** linter with auto-fix on save, snippets, and `<SPC>`-leader menus for every language layer
- **GitHub Copilot** support (disabled by default; one uncomment to re-enable after an active subscription)

### Multiplexer

- **Tmux** with `Ctrl-a` prefix, vim-style pane navigation (`PRE h/j/k/l`), splits on `PRE -` / `PRE _`
- **vim-tmux-navigator** so `C-h / C-j / C-k / C-l` move between Vim splits and tmux panes transparently
- `PRE ^` moves current window to position 1; `PRE C-p` toggles HTTP proxy on 127.0.0.1:8668; see [docs/tmux-keymaps.md](docs/tmux-keymaps.md)

### Git

- Hundreds of aliases (`ga`, `gc`, `gd`, `gfr`, `gpr-all` to rebase every subdirectory repo)
- `ghuse <alias>` — per-repo GitHub account switcher (sets `user.name/email` + rewrites remote URL to the right SSH host alias); `ghuse -g` for the global default
- Conventional-commits enforcement via commitlint + Husky

### Tools

- **asdf** version manager with pinned `~/.tool-versions`
- **ctags** with language-aware exclude lists
- `pdf2png`, `md2pdf`, `html2img`, `html2slides`, `yt-share`, `chrome-mcp`, `ferry` (two-way HTTP file bridge) in `bin/`

### AI

- **[Claude Code](https://claude.ai/code)** CLI config, notification hooks, custom status line showing session name + weekly rate-limit bar
- `yolo` — Claude Code with `--dangerously-skip-permissions`
- `ralphal` — autonomous iteration loop driving Claude Code from a `prd.json` task spec
- `set_proxy` / `proxy` with interactive port editing, bound to `PRE C-p` in tmux

---

## Project Structure

```
~/.lingti/
├── Rakefile              # Installation orchestrator
├── install.sh            # One-line bootstrap (served at lingti.com/code/install.sh)
├── lib/tasks/            # Modular rake tasks
├── zsh/                  # ZSH config (oh-my-zsh + custom files)
├── SpaceVim.d/           # Neovim config (init.toml, autoload/, snippets/)
├── git/                  # Git config
├── tmux/                 # Tmux config
├── claude/               # Claude Code config
├── bin/                  # CLI utilities (lingti command, pdf2png, ferry, chrome-mcp, …)
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
| [docs/tmux-keymaps.md](docs/tmux-keymaps.md) | Tmux keybindings reference |
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
rake install             # Full install (non-interactive)
rake install_fonts       # Terminal fonts for prompt glyphs
rake install_ohmyzsh     # ZSH/oh-my-zsh only
rake install_spacevim    # Neovim/SpaceVim only
rake install_asdf        # Version manager only
rake install_claude_code # Claude Code CLI (optional, large download)
rake install_claude      # Claude Code config only
rake install_gemini      # Gemini CLI only
rake set_default_shell   # Idempotently switch login shell to zsh

ASK=true rake install    # Interactive mode (per-section prompts)
DEBUG=true rake install  # Dry run
```

---

## Who Uses It

- **Industry**: [Suzhou Ruilisi Network Technology Co., Ltd.](https://lingti.com) — the Lingti product family (Game Booster, Router, Esports platform, AI stack, Xiemala collaboration tool), serving 10,000+ enterprises and 10,000,000+ individual users; this configuration ships their production code daily.
- **Academia**: 中国人民大学 智慧治理学院.
- **The ambition**: become the default development environment for anyone opening a new laptop — regardless of OS, language stack, or experience level.

Using lingti-code at your company or lab? Open a PR adding yourself here.

---

## License

[MIT](LICENSE) · [Credits](docs/credits.md) · [Changelog](CHANGELOG.md)
