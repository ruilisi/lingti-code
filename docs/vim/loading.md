# Neovim/SpaceVim Loading Process

This document explains in detail what happens when you open `nvim`, from the initial entry point to the fully configured editor.

## Overview

When Neovim starts, SpaceVim takes control and orchestrates a multi-phase loading process:

```
nvim
 └── ~/.SpaceVim/init.vim (entry point)
      ├── SpaceVim#begin()         # Framework initialization
      ├── SpaceVim#custom#load()   # User configuration
      │    ├── Parse init.toml
      │    ├── Apply [options]
      │    ├── Call bootstrap_before hook
      │    ├── Load [[layers]]
      │    ├── Load [[custom_plugins]]
      │    └── Register bootstrap_after hook
      ├── SpaceVim#default#keyBindings()
      └── SpaceVim#end()           # Plugin loading & finalization
           └── VimEnter event → bootstrap_after executes
```

## Directory Setup

After installation, SpaceVim creates:

| Location | Purpose |
|----------|---------|
| `~/.SpaceVim` | SpaceVim framework (cloned from git) |
| `~/.SpaceVim.d` | Symlink → `~/.lingti/SpaceVim.d/` (user config) |
| `~/.config/nvim` | Symlink → `~/.SpaceVim` |

The `~/.SpaceVim.d/` directory is added to Neovim's runtimepath, enabling:
- `autoload/` functions to be callable
- `after/` directory to override SpaceVim defaults
- `snippets/` to provide custom snippets

---

## Phase 1: Entry Point

**File:** `~/.SpaceVim/init.vim`

```vim
call SpaceVim#begin()
call SpaceVim#custom#load()
call SpaceVim#default#keyBindings()
call SpaceVim#end()
```

This is the first file Neovim executes, which delegates to SpaceVim's functions.

---

## Phase 2: Framework Initialization (`SpaceVim#begin()`)

**File:** `~/.SpaceVim/autoload/SpaceVim.vim`

Sets up the foundation:
- Configures UTF-8 encoding
- Initializes runtime path
- Parses startup arguments (files, directories)
- Prepares welcome screen for empty sessions
- Initializes logging system
- Configures terminal/GUI colors

---

## Phase 3: User Configuration Loading (`SpaceVim#custom#load()`)

**File:** `~/.SpaceVim/autoload/SpaceVim/custom.vim`

This is the most important phase for customization. It loads configurations in order:

### 3.1 Global Configuration

Searches `~/.SpaceVim.d/` for config files (in order of preference):

1. **`init.toml`** (preferred) - Parsed into cache: `~/.cache/SpaceVim/conf/init.json`
2. **`init.vim`** (legacy) - Executed directly as VimScript
3. **`init.lua`** (advanced) - Executed as Lua

**Caching:** TOML is parsed once and cached as JSON. Cache is reused if source file hasn't changed, speeding up subsequent startups.

### 3.2 Local (Project) Configuration

If not in `$HOME`, SpaceVim also looks for `.SpaceVim.d/init.toml` in the current project root. Project config takes precedence over global config.

### 3.3 Configuration Processing

The loaded config is processed in this order:

#### Step 1: Apply `[options]` Section

From `~/.lingti/SpaceVim.d/init.toml`:

```toml
[options]
colorscheme = "NeoSolarized"
colorscheme_bg = "dark"
enable_guicolors = false
guifont = "SauceCodePro Nerd Font Mono:h11"
vimcompatible = true
filemanager = "nerdtree"
lint_engine = 'ale'
bootstrap_before = "lingti#before"    # Hook: called BEFORE layers
bootstrap_after = "lingti#after"      # Hook: called AFTER everything
project_auto_root = true
...
```

#### Step 2: Call `bootstrap_before` Hook

**File:** `~/.lingti/SpaceVim.d/autoload/lingti.vim`

```vim
function! lingti#before() abort
  " Configure formatters BEFORE layers load
  let g:neoformat_typescriptreact_prettier = {
    \ 'exe': 'prettier',
    \ 'args': ['--stdin', '--stdin-filepath', '"%:p"', '--parser', 'typescript'],
    \ 'stdin': 1
  \ }
  let g:neoformat_enabled_typescriptreact = ['prettier']
  let g:neoformat_enabled_ruby = ['rubocop']
endfunction
```

**Purpose:** Pre-configure plugin options before layers are loaded.

#### Step 3: Load `[[layers]]`

Each layer in `init.toml` is loaded via `SpaceVim#layers#load()`:

```toml
[[layers]]
name = "lang#typescript"
auto_fix = true

[[layers]]
name = "lang#go"
format_on_save = true

[[layers]]
name = "lsp"
enabled_clients = ['pyright', 'gopls']
```

**What each layer provides:**
- Plugin declarations
- Syntax highlighting rules
- Language-specific keybindings
- LSP/linter/formatter configuration
- Filetype autocommands

**Layers in this config:**

| Layer | Purpose |
|-------|---------|
| `autocomplete` | nvim-cmp completion engine |
| `shell` | Integrated terminal |
| `lang#ruby` | Ruby language support |
| `lang#javascript` | JavaScript support |
| `lang#typescript` | TypeScript support |
| `lang#go` | Go support (gopls, staticcheck) |
| `lang#python` | Python support |
| `lang#rust` | Rust support |
| `lang#c` | C language support |
| `lang#markdown` | Markdown support |
| `lsp` | Language Server Protocol |
| `checkers` | Linting (ALE engine) |
| `format` | Code formatting |
| `git` | Git integration (fugitive) |
| `VersionControl` | VCS features |
| `tmux` | vim-tmux-navigator |
| `colorscheme` | Theme support |
| `leaderf` | Fuzzy finder |
| `gtags` | Global tags |
| `core` | Core functionality |
| `tools` | Utilities |
| `bookmarks` | Bookmark support |

#### Step 4: Load `[[custom_plugins]]`

```toml
[[custom_plugins]]
repo = "tveskag/nvim-blame-line.git"
merged = false

[[custom_plugins]]
repo = "zivyangll/git-blame.vim"

[[custom_plugins]]
repo = "github/copilot.vim"
```

Custom plugins are installed via SpaceVim's plugin manager and loaded after layers.

#### Step 5: Load Autoload Settings

At the end of `lingti.vim`, additional settings are dynamically loaded:

```vim
let vimsettings = '~/.lingti/SpaceVim.d/autoload/settings'
let uname = system("uname -s")

for fpath in split(globpath(vimsettings, '*.vim'), '\n')
  " Skip platform-specific files for wrong OS
  if (fpath == expand(vimsettings) . "/lingti-keymap-mac.vim") && uname[:4] ==? "linux"
    continue
  endif
  if (fpath == expand(vimsettings) . "/lingti-keymap-linux.vim") && uname[:4] !=? "linux"
    continue
  endif
  exe 'source' fpath
endfor
```

**Files loaded:**

| File | Purpose |
|------|---------|
| `neosnippet.vim` | Snippet expansion keys (`<C-e>`) |
| `lingti-keymap.vim` | General Lingti mappings (~325 lines) |
| `lingti-keymap-mac.vim` | macOS Command key mappings |
| `lingti-keymap-linux.vim` | Linux Alt key mappings |

**Platform-aware:** Detects OS via `uname -s` and skips inappropriate mappings.

#### Step 6: Register `bootstrap_after` Hook

The `bootstrap_after` function is registered to run on `VimEnter` event (after all initialization completes).

---

## Phase 4: Default Keybindings

**Function:** `SpaceVim#default#keyBindings()`

Loads SpaceVim's built-in keybindings for the Space key leader system.

---

## Phase 5: Finalization (`SpaceVim#end()`)

**File:** `~/.SpaceVim/autoload/SpaceVim.vim`

1. **Load Plugins:** `SpaceVim#plugins#load()` - Installs/loads all plugins from layers and custom_plugins
2. **Apply Colors:** Sets `termguicolors` if enabled
3. **Set Colorscheme:** `NeoSolarized` in dark mode
4. **Apply Font:** `SauceCodePro Nerd Font Mono:h11`
5. **Initialize Autocmds:** `SpaceVim#autocmds#init()` - File type detection, VimEnter hooks

---

## Phase 6: VimEnter Event (`bootstrap_after`)

**File:** `~/.lingti/SpaceVim.d/autoload/lingti.vim`

After everything is loaded, `VimEnter` triggers `lingti#after()`:

```vim
function! lingti#after() abort
  " Configure ALE fixers (must be after ALE loads)
  let g:ale_fixers = {
    \   'javascript': ['eslint', 'prettier'],
    \   'typescript': ['eslint', 'prettier'],
    \   'ruby': ['rubocop'],
    \}
  let g:ale_fix_on_save = 1
  let g:ctrlp_max_files=0

  " Configure neoformat
  let g:neoformat_enabled_javascript = ['eslint', 'prettier']
  let g:neoformat_enabled_javascriptreact = ['eslint', 'prettier']
  let g:neoformat_enabled_typescript = ['eslint', 'prettier']
  let g:neoformat_enabled_typescriptreact = ['eslint', 'prettier']

  call SpaceVim#layers#core#tabline#get()
endfunction
```

**Purpose:** Final configuration that requires plugins to be loaded first.

---

## Configuration Files Reference

| File | When Loaded | Purpose |
|------|-------------|---------|
| `SpaceVim.d/init.toml` | Phase 3 | Main config (options, layers, plugins) |
| `SpaceVim.d/autoload/lingti.vim` | Phase 3 | Bootstrap hooks & settings loader |
| `SpaceVim.d/autoload/settings/neosnippet.vim` | Phase 3 | Snippet keybindings |
| `SpaceVim.d/autoload/settings/lingti-keymap.vim` | Phase 3 | General vim mappings |
| `SpaceVim.d/autoload/settings/lingti-keymap-mac.vim` | Phase 3 | macOS mappings |
| `SpaceVim.d/autoload/settings/lingti-keymap-linux.vim` | Phase 3 | Linux mappings |
| `SpaceVim.d/snippets/*.snip` | On demand | Custom snippets |

---

## Key Design Patterns

### Bootstrap Hooks Pattern

```
bootstrap_before → Layers load → bootstrap_after
```

- **before:** Configure plugin options before plugins load
- **after:** Configure features that require plugins to exist

### Platform-Aware Loading

```vim
let uname = system("uname -s")
if uname[:4] ==? "linux"
  " Linux-specific config
endif
```

Single dotfiles repo works on both macOS and Linux with different keybindings.

### Configuration Caching

```
init.toml → parse → ~/.cache/SpaceVim/conf/init.json
                    ↑
              (reused if unchanged)
```

Speeds up startup by avoiding repeated TOML parsing.

### Runtimepath Extension

```vim
&rtp = '~/.SpaceVim.d,' . &rtp . ',~/.SpaceVim.d/after'
```

Allows user config to:
- Define `autoload/` functions
- Override layer defaults via `after/`
- Provide custom `snippets/`

---

## Debugging Startup

### Check Loading Order

```vim
:scriptnames          " List all sourced files in order
```

### Check Plugin Status

```vim
:SPUpdate            " Update/install plugins
:SPDebugInfo         " SpaceVim debug information
```

### Profile Startup Time

```bash
nvim --startuptime startup.log
cat startup.log
```

### Check Layer Status

```vim
:echo SpaceVim#layers#isLoaded('lang#typescript')
```

---

## Adding Custom Configuration

### Option 1: Edit init.toml

For layers and plugins, modify `~/.SpaceVim.d/init.toml`.

### Option 2: Bootstrap Hooks

For VimScript configuration, edit `~/.lingti/SpaceVim.d/autoload/lingti.vim`:
- `lingti#before()` - Before layers load
- `lingti#after()` - After everything loads

### Option 3: Settings Files

Add new `.vim` files to `~/.lingti/SpaceVim.d/autoload/settings/` - they're auto-loaded.

### Option 4: After Directory

Create `~/.SpaceVim.d/after/plugin/myconfig.vim` to override anything.
