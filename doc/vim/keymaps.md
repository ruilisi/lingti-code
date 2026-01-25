The files in `vim/settings` are customizations stored on a per-plugin
basis. The main keymap is available in lingti-keymap.vim, but some of the vim
files contain key mappings as well.

If you are having unexpected behavior, wondering why a particular key works the way it does,
use: `:map [keycombo]` (e.g. `:map <C-\>`) to see what the key is mapped to. For bonus points, you can see where the mapping was set by using `:verbose map [keycombo]`.
If you omit the key combo, you'll get a list of all the maps. You can do the same thing with nmap, imap, vmap, etc.

## Finding Filetype-Specific Keymaps (SpaceVim)

To find the original definition of a language-specific keymap like `<SPC> l e` for Go files:

### 1. Use `:verbose map`

With the relevant filetype open (e.g., a `.go` file):

```vim
:verbose nmap <Space>le
```

This shows where the mapping was last defined.

### 2. Check the layer source directly

Language keymaps are defined in SpaceVim layer files:

```
~/.SpaceVim/autoload/SpaceVim/layers/lang/<language>.vim
```

For example, Go keymaps:

```bash
grep -n "l e" ~/.SpaceVim/autoload/SpaceVim/layers/lang/go.vim
```

### 3. Use SpaceVim's built-in help

```vim
:h SpaceVim-layers-lang-go
```

Or press `<SPC> h l` to list all layers and their keybindings.

### 4. Check current binding

```vim
:nmap <Space>le
```

### 5. Online documentation

SpaceVim documents layer keybindings at `https://spacevim.org/layers/lang/<language>/`

---

## Language-Specific Keymaps Reference

All language keymaps use the `<SPC> l` prefix (Space + l). These are only active when editing files of the corresponding filetype.

### Common LSP Keymaps (All Languages with LSP)

When LSP is enabled for a language, these keymaps are available:

| Key | Function |
|-----|----------|
| `g d` | Go to definition |
| `g D` | Go to type definition |
| `K` | Show documentation |
| `SPC l d` | Show document |
| `SPC l e` | Rename symbol |
| `SPC l x` | Show references |
| `SPC l h` | Show line diagnostics |
| `SPC l w l` | List workspace folders |
| `SPC l w a` | Add workspace folder |
| `SPC l w r` | Remove workspace folder |

### Common REPL Keymaps (Languages with REPL support)

| Key | Function |
|-----|----------|
| `SPC l s i` | Start REPL process |
| `SPC l s b` | Send whole buffer |
| `SPC l s l` | Send current line |
| `SPC l s s` | Send selection |

---

### Go (`*.go`)

| Key | Function |
|-----|----------|
| `SPC l a` | Go alternate (test ↔ implementation) |
| `SPC l b` | Go build |
| `SPC l c` | Go coverage toggle |
| `SPC l d` | Go doc |
| `SPC l D` | Go doc (vertical split) |
| `SPC l e` | Go rename |
| `SPC l g` | Go to definition |
| `SPC l G` | Go generate |
| `SPC l h` | Go info |
| `SPC l i` | Go implements |
| `SPC l I` | Implement interface stubs |
| `SPC l k` | Add struct tags |
| `SPC l K` | Remove struct tags |
| `SPC l l` | List declarations in file |
| `SPC l L` | List declarations in directory |
| `SPC l m` | Format imports |
| `SPC l M` | Add import |
| `SPC l r` | Run current file |
| `SPC l s` | Fill struct (without LSP) / Show diagnostics (with LSP) |
| `SPC l t` | Go test |
| `SPC l T` | Go test function |
| `SPC l v` | Freevars |
| `SPC l x` | Go referrers |

---

### JavaScript (`*.js`, `*.jsx`)

| Key | Function |
|-----|----------|
| `SPC l r` | Run current file |
| `SPC l d` | Show document (TernDoc / LSP) |
| `SPC l e` | Rename symbol |
| `SPC l g d` | Generate JSDoc |
| `SPC l s i` | Start REPL (node) |
| `SPC l s b` | Send buffer to REPL |
| `SPC l s l` | Send line to REPL |
| `SPC l s s` | Send selection to REPL |
| `F4` | Import JS word |
| `<Leader>ji` | Import JS word |
| `<Leader>jf` | Import JS fix |
| `<Leader>jg` | Import JS goto |

---

### TypeScript (`*.ts`, `*.tsx`)

| Key | Function |
|-----|----------|
| `g D` | Jump to type definition |
| `SPC l d` | Show document |
| `SPC l e` | Rename symbol |
| `SPC l f` | Code fix (Neovim) |
| `SPC l i` | Import |
| `SPC l m` | Interface implementations (Vim) |
| `SPC l o` | Organize imports (Neovim) |
| `SPC l p` | Preview definition (Neovim) |
| `SPC l r` | Run current file |
| `SPC l R` | Show references (Neovim) |
| `SPC l t` | View type (Neovim) |
| `SPC l D` | Show errors (Neovim) |
| `SPC l g d` | Generate JSDoc |
| `SPC l s i` | Start REPL (ts-node) |
| `SPC l s b` | Send buffer to REPL |
| `SPC l s l` | Send line to REPL |
| `SPC l s s` | Send selection to REPL |

---

### Python (`*.py`)

| Key | Function |
|-----|----------|
| `g d` | Jump to definition |
| `SPC l r` | Run current file |
| `SPC l d` | Show document (with LSP) |
| `SPC l e` | Rename symbol (with LSP) |
| `SPC l h` | Show line diagnostics (with LSP) |
| `SPC l x` | Show references (with LSP) |
| `SPC l i s` | Sort imports (isort) |
| `SPC l i r` | Remove unused imports (autoflake) |
| `SPC l i i` | Import name under cursor |
| `SPC l c r` | Coverage report |
| `SPC l c s` | Coverage show |
| `SPC l c e` | Coverage session |
| `SPC l c f` | Coverage refresh |
| `SPC l g d` | Generate docstring |
| `SPC l v l` | List all virtualenvs |
| `SPC l v d` | Deactivate current virtualenv |
| `SPC l s i` | Start REPL (ipython/python) |
| `SPC l s b` | Send buffer to REPL |
| `SPC l s l` | Send line to REPL |
| `SPC l s s` | Send selection to REPL |

---

### Ruby (`*.rb`)

| Key | Function |
|-----|----------|
| `SPC l r` | Run current file |
| `SPC l d` | Show document (with LSP) |
| `SPC l e` | Rename symbol (with LSP) |
| `SPC l h` | Show line diagnostics (with LSP) |
| `SPC l x` | Show references (with LSP) |
| `SPC l s i` | Start REPL (irb) |
| `SPC l s b` | Send buffer to REPL |
| `SPC l s l` | Send line to REPL |
| `SPC l s s` | Send selection to REPL |

**LSP Setup:** Install solargraph: `gem install --user-install solargraph`

---

### Rust (`*.rs`)

| Key | Function |
|-----|----------|
| `g d` | Go to definition |
| `K` | Show documentation |
| `SPC l d` | Show documentation |
| `SPC l e` | Rename symbol (with LSP) |
| `SPC l g` | Definition in split (without LSP) |
| `SPC l h` | Show line diagnostics (with LSP) |
| `SPC l r` | Run current file |
| `SPC l u` | Show references (without LSP) |
| `SPC l v` | Definition in vertical split (without LSP) |
| `SPC l x` | Show references (with LSP) |
| `SPC l c b` | Cargo build |
| `SPC l c B` | Cargo bench |
| `SPC l c c` | Cargo clean |
| `SPC l c D` | Cargo doc |
| `SPC l c f` | Cargo fmt |
| `SPC l c l` | Cargo clippy |
| `SPC l c r` | Cargo run |
| `SPC l c t` | Cargo test |
| `SPC l c u` | Cargo update |
| `SPC l s i` | Start REPL (evcxr) |
| `SPC l s b` | Send buffer to REPL |
| `SPC l s l` | Send line to REPL |
| `SPC l s s` | Send selection to REPL |

---

### C/C++ (`*.c`, `*.cpp`, `*.h`, `*.hpp`)

| Key | Function |
|-----|----------|
| `g d` | Go to definition |
| `g D` | Go to declaration |
| `K` | Show documentation (with LSP) |
| `SPC l r` | Run current file |
| `SPC l d` | Show document (with LSP) |
| `SPC l e` | Rename symbol (with LSP) |
| `SPC l h` | Show line diagnostics (with LSP) |
| `SPC l i` | Go to implementation (with LSP) |
| `SPC l x` | Show references (with LSP) |
| `SPC l s i` | Start REPL (igcc) |
| `SPC l s b` | Send buffer to REPL |
| `SPC l s l` | Send line to REPL |
| `SPC l s s` | Send selection to REPL |

---

### Markdown (`*.md`)

| Key | Function |
|-----|----------|
| `Ctrl-b` | Insert code block |
| `SPC l c` | Create table of contents (GFM) |
| `SPC l C` | Remove table of contents |
| `SPC l f` | Format code block |
| `SPC l k` | Add link URL |
| `SPC l K` | Add link picture |
| `SPC l p` | Real-time markdown preview |
| `SPC l r` | Run code in code block |
| `SPC l t` | Toggle checkbox |
| `SPC l u` | Update table of contents |

---

### Notes

- Keymaps marked "(with LSP)" require the LSP layer to be enabled for that language
- Keymaps marked "(without LSP)" are only available when LSP is not enabled
- REPL keymaps require the appropriate REPL tool to be installed (e.g., `ipython` for Python, `irb` for Ruby)
