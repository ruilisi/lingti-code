# LSP (Language Server Protocol)

SpaceVim uses **nvim-lspconfig** (neovim native LSP) via the `lsp` layer.
Active clients are declared in `SpaceVim.d/init.toml` under `[[layers]] name = "lsp"`.

```toml
[[layers]]
name = "lsp"
enabled_clients = ['pyright', "gopls", "tsserver", "sourcekit", "solargraph", "rust_analyzer"]
```

---

## Keymaps (all LSP-enabled filetypes)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to type definition |
| `gr` | Find references |
| `gi` | Go to implementation |
| `K` | Show hover documentation |
| `<leader>rn` | Rename symbol |
| `SPC l d` | Show document |
| `SPC l e` | Rename symbol |
| `SPC l s` | Show line diagnostics |
| `SPC l x` | Find references |

---

## Clients & Installation

### Python — `pyright`

```bash
npm install -g pyright
```

### Go — `gopls`

```bash
go install golang.org/x/tools/gopls@latest
```

Custom flag in config (shared daemon mode):

```toml
[layers.override_cmd]
gopls = ['gopls', '-remote=auto']
```

### TypeScript / JavaScript — `tsserver`

```bash
npm install -g typescript typescript-language-server
```

`gd` uses `_typescript.goToSourceDefinition` to jump to source instead of stopping at re-exports.

### Swift / ObjC — `sourcekit`

Bundled with **Xcode**. Requires Xcode to be installed and selected:

```bash
xcode-select --install
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
```

Root detection is customised in `SpaceVim.d/lua/lingti/lsp.lua` to prefer `Package.swift` over `.git` for Find References to work in multi-package repos.

### Ruby — `solargraph`

```bash
gem install solargraph
```

### Rust — `rust_analyzer`

Install via rustup (recommended — keeps in sync with the toolchain):

```bash
rustup component add rust-analyzer
```

Verify:

```bash
rust-analyzer --version
```

> **Note:** `rust-analyzer` is a toolchain component, not a standalone binary in PATH.
> The `rustup`-managed wrapper at `~/.cargo/bin/rust-analyzer` is what nvim-lspconfig invokes.

---

## Diagnostics

Diagnostics are handled by the `checkers` layer (ALE engine):

```toml
[[layers]]
name = "checkers"
enable_ale = true
```

| Key | Action |
|-----|--------|
| `SPC l s` | Show current line diagnostics |
| `]e` / `[e` | Jump to next/previous error |

---

## Troubleshooting

**Check if an LSP client is attached to the current buffer:**

```vim
:lua print(vim.inspect(vim.lsp.get_clients({bufnr=0})))
```

**Check LSP log for errors:**

```vim
:lua vim.cmd('edit ' .. vim.lsp.get_log_path())
```

**Verify the binary is executable:**

```bash
which rust-analyzer
which gopls
which pyright
which typescript-language-server
which solargraph
```

**Reload LSP for current buffer:**

```vim
:LspRestart
```
