# Nerd Fonts Setup Guide

Nerd Fonts are patched fonts that include icons (glyphs) for file types, git status, and other development symbols. This guide covers installation and configuration for use with Neovim, iTerm2, and related plugins.

## How It Works

```
┌─────────────────────────────────────────────────────────────────┐
│                        Architecture                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Terminal (iTerm2)                                               │
│  └── Font: SauceCodePro Nerd Font Mono                          │
│       └── Renders icon glyphs (e.g., , , , )               │
│                                                                  │
│  Neovim                                                          │
│  ├── nvim-web-devicons (provides icon mappings)                  │
│  │   └── Maps file extensions → icon characters                  │
│  │                                                               │
│  └── Plugins that use icons:                                     │
│      ├── LeaderF (fuzzy finder)                                  │
│      ├── NERDTree / nvim-tree (file explorer)                    │
│      ├── lualine / airline (statusline)                          │
│      └── startify (start screen)                                 │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Key concept**: Neovim plugins output Unicode characters (e.g., `\uf07b` for folder icon). The terminal's font must contain glyphs for these characters to render as icons instead of `?` or boxes.

## Installation

### 1. Download and Install the Font

```bash
# Download SauceCodePro Nerd Font
curl -fL https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/SourceCodePro.zip \
  -o /tmp/SourceCodePro.zip

# Extract
cd /tmp && unzip -o SourceCodePro.zip -d SourceCodePro

# Install to user fonts directory (macOS)
/bin/cp /tmp/SourceCodePro/SauceCodeProNerdFont-Regular.ttf ~/Library/Fonts/
/bin/cp /tmp/SourceCodePro/SauceCodeProNerdFontMono-Regular.ttf ~/Library/Fonts/

# Verify installation
ls -lh ~/Library/Fonts/SauceCodePro*
# Should show ~2MB files, not tiny placeholder files
```

### 2. Configure iTerm2

1. **Quit iTerm2 completely** (Cmd+Q)
2. Reopen iTerm2
3. Open **Preferences** (Cmd+,)
4. Go to **Profiles** → select your profile → **Text** tab
5. Click **Font** and select **"SauceCodePro Nerd Font Mono"**
6. Recommended size: 12-14pt

### 3. Configure Neovim/SpaceVim

Add to your SpaceVim `init.toml`:

```toml
[options]
    # For GUI Neovim (Neovide, VimR) - not needed for terminal
    guifont = "SauceCodePro Nerd Font Mono:h13"
```

Enable devicons in LeaderF by adding to your bootstrap function (`~/.SpaceVim.d/autoload/yourconfig.vim`):

```vim
function! yourconfig#before() abort
  " Enable devicons in LeaderF file list
  let g:Lf_ShowDevIcons = 1
endfunction
```

Add nvim-web-devicons plugin in `init.toml`:

```toml
[[custom_plugins]]
repo = "nvim-tree/nvim-web-devicons"
merged = false
```

## Font Variants Explained

| Variant | Description | Use Case |
|---------|-------------|----------|
| **Nerd Font Mono** | Icons are single-character width | Terminal, Neovim - maintains column alignment |
| **Nerd Font** | Icons are double-width | GUI apps where alignment is less critical |
| **Nerd Font Propo** | Proportional (variable width) | Not recommended for coding |

**Recommendation**: Always use **Mono** variant for terminals and code editors.

## Plugin Configuration

### LeaderF

LeaderF shows file type icons in the fuzzy finder file list.

```vim
" Enable devicons (add to bootstrap_before function)
let g:Lf_ShowDevIcons = 1
```

### nvim-web-devicons

This plugin provides the icon-to-filetype mappings used by many other plugins.

```toml
# init.toml
[[custom_plugins]]
repo = "nvim-tree/nvim-web-devicons"
merged = false
```

No additional configuration needed - it auto-detects file types.

### NERDTree

NERDTree can show icons if you have nvim-web-devicons or vim-devicons installed.

```toml
# init.toml - enable filetype icons in filetree
[[layers]]
name = 'core'
enable_filetree_filetypeicon = true
```

### Statusline (airline/lualine)

SpaceVim's statusline automatically uses icons when available:

```toml
[options]
    enable_tabline_filetype_icon = true
    statusline_unicode_symbols = true
```

## Troubleshooting

### Icons show as `?` or boxes

1. **Verify font file is valid** (not a failed download):
   ```bash
   ls -lh ~/Library/Fonts/SauceCodePro*
   # Should be ~2MB, not 14 bytes
   ```

2. **Check terminal font setting**: iTerm2 must be configured to use the Nerd Font (Neovim's `guifont` only affects GUI versions)

3. **Restart terminal**: Font changes require a full restart of iTerm2

4. **Test in terminal**:
   ```bash
   echo -e "Folder: \uf07b  File: \uf15b  Git: \ue0a0"
   ```
   If you see icons, the font is working.

### Icons misaligned or cut off

Use the **Mono** variant instead of the regular Nerd Font.

### LeaderF not showing icons

1. Verify `let g:Lf_ShowDevIcons = 1` is set in bootstrap_before
2. Ensure nvim-web-devicons plugin is installed
3. Restart Neovim after changes

## Common Icon Characters

| Icon | Unicode | Description |
|------|---------|-------------|
|  | `\uf07b` | Folder |
|  | `\uf15b` | File |
|  | `\ue627` | Go |
|  | `\ue791` | TypeScript |
|  | `\ue739` | JavaScript |
|  | `\ue73c` | Python |
|  | `\ue791` | Ruby |
|  | `\ue7a8` | Rust |
|  | `\ue0a0` | Git branch |

## Resources

- [Nerd Fonts GitHub](https://github.com/ryanoasis/nerd-fonts)
- [Nerd Fonts Cheat Sheet](https://www.nerdfonts.com/cheat-sheet) - Search for icons
- [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)
