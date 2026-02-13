# Keymaps Reference

Complete keymap documentation for Lingti + SpaceVim configuration.

**Leader Keys:**
- `<Space>` (SPC) - SpaceVim leader
- `,` - Local leader / Lingti utilities
- `<leader>` - Vim leader (usually `\`)

---

# 1. Shell (Zsh)

## 1.1 Command Line Editing

### Navigation & History
| Keymap | Action | Mode |
|--------|--------|------|
| `Ctrl-R` | Vim mode and bash style historical reverse search | Zsh |
| `ESC C-x C-e` | Edit current command line in vim | Zsh |

### Alias Management
| Keymap | Action | Mode |
|--------|--------|------|
| `ae` | Edit aliases | Zsh |
| `ar` | Reload aliases | Zsh |

---

# 2. Tmux

## 2.1 Pane Management

Prefix is defined as `C-a` (`PRE` for short)

### Pane Navigation
| Keymap | Action | Mode |
|--------|--------|------|
| `C-h` | Move to left pane | Tmux |
| `C-j` | Move to pane below | Tmux |
| `C-k` | Move to pane above | Tmux |
| `C-l` | Move to right pane | Tmux |
| `PRE o` | Go to next pane (cycle) | Tmux |
| `PRE ;` | Go to last (previously used) pane | Tmux |
| `PRE 1-9` | Jump to pane 1-9 | Tmux |

### Pane Creation & Splitting
| Keymap | Action | Mode |
|--------|--------|------|
| `PRE c` | Create a new pane | Tmux |
| `PRE s` | Split panes horizontally (up/down) | Tmux |
| `PRE v` | Split panes vertically (left/right) | Tmux |

### Pane Actions
| Keymap | Action | Mode |
|--------|--------|------|
| `PRE x` | Kill pane | Tmux |
| `PRE z` | Zoom/Unzoom pane | Tmux |
| `PRE !` | Move current pane to new window | Tmux |
| `PRE {` | Move pane to previous position | Tmux |
| `PRE }` | Move pane to next position | Tmux |
| `PRE C-o` | Rotate window up (move all panes) | Tmux |
| `PRE M-o` | Rotate window down | Tmux |
| `PRE m` | Mark pane | Tmux |

### Pane Resize
| Keymap | Action | Mode |
|--------|--------|------|
| `PRE h` | Resize pane left | Tmux |
| `PRE j` | Resize pane down | Tmux |
| `PRE k` | Resize pane up | Tmux |
| `PRE l` | Resize pane right | Tmux |

## 2.2 Window Management

### Window Actions
| Keymap | Action | Mode |
|--------|--------|------|
| `PRE ,` | Rename window | Tmux |
| `PRE d` | Detach from session | Tmux |
| `PRE D` | Choose session to detach | Tmux |
| `PRE >` | Show cheatsheet | Tmux |
| `PRE <` | Show cheatsheet | Tmux |

## 2.3 Copy Mode

Press `PRE [` to enter Scroll/Copy Mode

### Copy Mode Operations
| Keymap | Action | Mode |
|--------|--------|------|
| `Shift-V` | Select text (visual line) | Copy Mode |
| `Enter` | Copy selected text | Copy Mode |
| `]` | Paste text copied from scroll mode | Normal |

---

# 3. Vim Navigation

## 3.1 Window Management

### Window Movement
| Keymap | Action | Mode |
|--------|--------|------|
| `<SPC>w h` | Move to left window | Normal |
| `<SPC>w j` | Move to window below | Normal |
| `<SPC>w k` | Move to window above | Normal |
| `<SPC>w l` | Move to right window | Normal |
| `<SPC>w w` | Cycle between windows | Normal |
| `<SPC>w W` | Select window (choosewin) | Normal |
| `<SPC>w <Tab>` | Switch to alternate window | Normal |

### Window Positioning
| Keymap | Action | Mode |
|--------|--------|------|
| `<SPC>w H` | Move window to far left | Normal |
| `<SPC>w J` | Move window to far down | Normal |
| `<SPC>w K` | Move window to far up | Normal |
| `<SPC>w L` | Move window to far right | Normal |
| `<SPC>w x` | Exchange with next window | Normal |
| `<SPC>w M` | Swap windows (choosewin) | Normal |

### Window Split
| Keymap | Action | Mode |
|--------|--------|------|
| `vv` | Vertical split | Normal |
| `ss` | Horizontal split | Normal |
| `<SPC>w v` / `<SPC>w /` | Vertical split | Normal |
| `<SPC>w V` | Vertical split, focus new | Normal |
| `<SPC>w s` / `<SPC>w -` | Horizontal split | Normal |
| `<SPC>w S` | Horizontal split, focus new | Normal |
| `<SPC>w 2` | Layout double columns | Normal |
| `<SPC>w 3` | Layout three columns | Normal |
| `<SPC>w =` | Balance split windows | Normal |
| `<C-w>f` | Split and edit file under cursor | Normal |
| `<C-w>gf` | Tab and edit file under cursor | Normal |

### Window Actions
| Keymap | Action | Mode |
|--------|--------|------|
| `<SPC>w d` | Close current window | Normal |
| `<SPC>w D` | Delete another window | Normal |
| `<SPC>w m` | Maximize/minimize window | Normal |
| `<SPC>w +` | Toggle windows layout | Normal |
| `<SPC>w .` | Windows transient state | Normal |
| `<SPC>w u` | Undo window quit | Normal |
| `<SPC>w U` | Redo window quit | Normal |
| `,gz` | Zoom in (close other windows) | Normal |

### Window Resize (Mac)
| Keymap | Action | Mode |
|--------|--------|------|
| `<D-Up>` | Increase window height | Normal |
| `<D-Down>` | Decrease window height | Normal |
| `<D-Left>` | Decrease window width | Normal |
| `<D-Right>` | Increase window width | Normal |

### Window Resize (Linux)
| Keymap | Action | Mode |
|--------|--------|------|
| `<C-Up>` | Increase window height | Normal |
| `<C-Down>` | Decrease window height | Normal |
| `<C-Left>` | Decrease window width | Normal |
| `<C-Right>` | Increase window width | Normal |

## 3.2 Buffer Management

### Buffer Navigation
| Keymap | Action | Mode |
|--------|--------|------|
| `,z` | Previous buffer | Normal |
| `,x` | Next buffer | Normal |
| `<SPC>b n` | Next buffer | Normal |
| `<SPC>b p` | Previous buffer | Normal |
| `<SPC>b s` | Switch to scratch buffer | Normal |
| `<leader><leader>` | Switch between last two files | Normal |

### Buffer Actions
| Keymap | Action | Mode |
|--------|--------|------|
| `<leader>bd` | Close current buffer | Normal |
| `<leader>bda` | Close all buffers | Normal |

## 3.3 Tab Management

### Tab Navigation
| Keymap | Action | Mode |
|--------|--------|------|
| `<leader>tn` | New tab | Normal |
| `<leader>to` | Tab only (close others) | Normal |
| `<leader>tc` | Close current tab | Normal |
| `<leader>tm` | Move tab | Normal |
| `<leader>tl` | Toggle last accessed tab | Normal |
| `<SPC>w F` | Create new tab | Normal |
| `<SPC>w o` | Switch to next tab | Normal |
| `<SPC>F n` | Create new tab | Normal |
| `<SPC>F d` | Close current tab | Normal |
| `<SPC>F D` | Close other tabs | Normal |

### Tab Jump (Mac: Cmd, Linux: Alt)
| Keymap | Action | Mode |
|--------|--------|------|
| `<D-1>` to `<D-9>` | Jump to tab 1-9 (Mac) | Normal |
| `<A-1>` to `<A-9>` | Jump to tab 1-9 (Linux) | Normal |

## 3.4 File Explorer

### NERDTree
| Keymap | Action | Mode |
|--------|--------|------|
| `<C-\>` | Toggle NERDTree / Find file | Normal |
| `<D-N>` | Toggle NERDTree (Mac) | Normal |
| `<A-N>` | Toggle NERDTree (Linux) | Normal |

## 3.5 Cursor Movement

### Basic Movement
| Keymap | Action | Mode |
|--------|--------|------|
| `0` | Go to first character (not space) | Normal |
| `^` | Go to first column | Normal |
| `j` | Move down (respects wrapped lines) | Normal |
| `k` | Move up (respects wrapped lines) | Normal |
| `,.` | Go to last edit location | Normal |

### Mark Navigation
| Keymap | Action | Mode |
|--------|--------|------|
| `'` | Jump to line and column | Normal |
| `` ` `` | Jump to line only | Normal |

### Function Navigation (Mac)
| Keymap | Action | Mode |
|--------|--------|------|
| `<D-j>` | Next function/method | Normal |
| `<D-k>` | Previous function/method | Normal |

### Function Navigation (Linux)
| Keymap | Action | Mode |
|--------|--------|------|
| `<A-j>` | Next function/method | Normal |
| `<A-k>` | Previous function/method | Normal |

---

# 4. Vim Editing

## 4.1 Text Objects & Surround

### Surround Operations
| Keymap | Action | Mode |
|--------|--------|------|
| `,#` | Surround with #{ruby interpolation} | Normal/Visual |
| `,"` | Surround with "double quotes" | Normal/Visual |
| `,'` | Surround with 'single quotes' | Normal/Visual |
| `,(` / `,)` | Surround with (parentheses) | Normal/Visual |
| `,[` / `,]` | Surround with [brackets] | Normal/Visual |
| `,{` / `,}` | Surround with {braces} | Normal/Visual |
| `,`` | Surround with backticks | Normal |

### Quick Change Inside (Mac: Cmd, Linux: Alt)
| Keymap | Action | Mode |
|--------|--------|------|
| `<D-'>` / `<A-'>` | Find and change inside single quote | Normal |
| `<D-">` / `<A-">` | Find and change inside double quote | Normal |
| `<D-(>` / `<A-(>` | Find and change inside parens | Normal |
| `<D-[>` / `<A-[>` | Find and change inside brackets | Normal |

## 4.2 Yank & Paste

### Yank Operations
| Keymap | Action | Mode |
|--------|--------|------|
| `,yw` | Yank entire word | Normal |
| `Y` | Yank to end of line | Normal |
| `<C-C>` | Copy selection | Visual |
| `<C-X><C-A>` | Copy all text | Normal |
| `<C-A>` | Copy all inside vim | Normal |

### Paste Operations
| Keymap | Action | Mode |
|--------|--------|------|
| `<C-X><C-V>` | Paste text | Normal/Insert |
| `,ow` | Overwrite word with yank buffer | Normal |

### Inter-Vim Copy/Paste
| Keymap | Action | Mode |
|--------|--------|------|
| `<leader>y` | Copy to ~/.vbuf | Visual |
| `<leader>p` | Paste from ~/.vbuf | Normal |

## 4.3 Line Operations

### Split/Join
| Keymap | Action | Mode |
|--------|--------|------|
| `sj` | SplitJoin: Split line | Normal |
| `sk` | SplitJoin: Join line | Normal |

### Indentation
| Keymap | Action | Mode |
|--------|--------|------|
| `<` | Decrease indent (stay in visual) | Visual |
| `>` | Increase indent (stay in visual) | Visual |

## 4.4 Insert Mode Helpers

### Quick Insert
| Keymap | Action | Mode |
|--------|--------|------|
| `<C-l>` | Insert ` => ` (hashrocket) | Insert |
| `<C-a>` | Exit string auto-complete | Insert |
| `<C-K>` | Insert `<%= %>` ERB tag | Insert |
| `<C-J>` | Insert `<% %>` ERB tag / Copilot accept | Insert |
| `<C-L>` | Copy character from line above | Insert |
| `<leader>cb` | Insert Chinese brackets 『』 | Insert |
| `<leader>fn` | Insert current filename | Insert |

### RSI Prevention (Mac)
| Keymap | Action | Mode |
|--------|--------|------|
| `<D-k>` / `<D-d>` | Type underscore | Insert |
| `<D-K>` / `<D-D>` | Type dash | Insert |

### RSI Prevention (Linux)
| Keymap | Action | Mode |
|--------|--------|------|
| `<A-k>` / `<A-d>` | Type underscore | Insert |
| `<A-K>` / `<A-D>` | Type dash | Insert |

## 4.5 Comments

### Toggle Comments
| Keymap | Action | Mode |
|--------|--------|------|
| `<D-/>` | Toggle comment (Mac) | Normal/Insert |
| `<A-/>` | Toggle comment (Linux) | Normal/Insert |

## 4.6 Alignment

### Tabularize
| Keymap | Action | Mode |
|--------|--------|------|
| `<D-A>` | Tabularize alignment (Mac) | Normal/Visual |
| `<A-A>` | Tabularize alignment (Linux) | Normal/Visual |

---

# 5. Search & Find

## 5.1 Basic Search

### Search Control
| Keymap | Action | Mode |
|--------|--------|------|
| `//` | Clear search highlight | Normal |
| `,hl` | Toggle highlighting | Normal |
| `*` | Search selection forward | Visual |
| `#` | Search selection backward | Visual |

## 5.2 Grep Operations (SPC s)

### Buffer Search
| Keymap | Action | Mode |
|--------|--------|------|
| `<SPC>s s` | Grep in current buffer | Normal |
| `<SPC>s S` | Grep cword in current buffer | Normal |
| `<SPC>s b` | Grep in all loaded buffers | Normal |
| `<SPC>s B` | Grep cword in all buffers | Normal |

### Directory Search
| Keymap | Action | Mode |
|--------|--------|------|
| `<SPC>s d` | Grep in buffer directory | Normal |
| `<SPC>s D` | Grep cword in buffer directory | Normal |
| `<SPC>s f` | Grep in arbitrary directory | Normal |
| `<SPC>s F` | Grep cword in arbitrary directory | Normal |

### Project Search
| Keymap | Action | Mode |
|--------|--------|------|
| `<SPC>s p` | Grep in project | Normal |
| `<SPC>s P` | Grep cword in project | Normal |
| `<SPC>s j` | Background search in project | Normal |
| `<SPC>s J` | Background search cword in project | Normal |

### Search Utilities
| Keymap | Action | Mode |
|--------|--------|------|
| `<SPC>s /` | Grep on the fly | Normal |
| `<SPC>s l` | List all search results | Normal |
| `<SPC>s c` | Clear search results | Normal |

## 5.3 Search Tool Namespaces

Use `<SPC>s {tool} {scope}` pattern:

**Tools:** `a`=ag, `g`=grep, `G`=git-grep, `k`=ack, `r`=rg, `t`=pt

**Scopes:** `b`=buffers, `d`=directory, `p`=project, `f`=arbitrary, `j`=background

Example: `<SPC>s a p` = ag search in project

---

# 6. Git Operations

## 6.1 Basic Git (SPC g)

### File Operations
| Keymap | Action | Mode |
|--------|--------|------|
| `<SPC>g s` | Git status | Normal |
| `<SPC>g S` | Stage current file | Normal |
| `<SPC>g U` | Unstage current file | Normal |
| `<SPC>g A` | Stage all files | Normal |
| `<SPC>g d` | View git diff | Normal |

### Commit & Push
| Keymap | Action | Mode |
|--------|--------|------|
| `<SPC>g c` | Edit git commit | Normal |
| `<SPC>g p` | Git push | Normal |

### History & Blame
| Keymap | Action | Mode |
|--------|--------|------|
| `<SPC>g b` | Open git blame | Normal |
| `<SPC>g V` | Git log of current file | Normal |
| `<SPC>g v` | Git log of current repo | Normal |
| `<SPC>g M` | Show commit message of line | Normal |
| `<leader>b` | Toggle blame line | Normal |
| `<leader>s` | Echo blame info | Normal |

### Branch & Remote
| Keymap | Action | Mode |
|--------|--------|------|
| `<SPC>g m` | Git branch manager | Normal |
| `<SPC>g r` | Git remote manager | Normal |

## 6.2 Git Hunks

### Hunk Navigation
| Keymap | Action | Mode |
|--------|--------|------|
| `] c` | Go to next git hunk | Normal |
| `[ c` | Go to previous git hunk | Normal |

### Hunk Operations (SPC g h)
| Keymap | Action | Mode |
|--------|--------|------|
| `<SPC>g h a` / `<SPC>g h s` | Stage current hunk | Normal |
| `<SPC>g h r` | Undo cursor hunk | Normal |
| `<SPC>g h v` | Preview cursor hunk | Normal |

---

# 7. LSP (Global)

These keybindings are applied automatically to any buffer with an active LSP client via the `LspAttach` autocmd.

## 7.1 Navigation

| Keymap | Action | Mode |
|--------|--------|------|
| `gd` | Go to definition (TS/JS: source definition) | Normal |
| `gD` | Go to type definition | Normal |
| `gr` | Find references | Normal |
| `gi` | Go to implementation | Normal |
| `K` | Show hover documentation | Normal |

## 7.2 Refactoring

| Keymap | Action | Mode |
|--------|--------|------|
| `<leader>rn` | Rename symbol | Normal |

## 7.3 SPC l (Language)

| Keymap | Action | Mode |
|--------|--------|------|
| `<SPC>l d` | Show documentation | Normal |
| `<SPC>l e` | Rename symbol | Normal |
| `<SPC>l s` | Show line diagnostics | Normal |

---

# 8. Language-Specific

## 8.1 Markdown (SPC l)

### Preview & Links
| Keymap | Action | Mode |
|--------|--------|------|
| `<SPC>l p` | Real-time markdown preview | Normal |
| `<SPC>l k` | Add link URL | Normal |
| `<SPC>l K` | Add link picture | Normal |

### Table of Contents
| Keymap | Action | Mode |
|--------|--------|------|
| `<SPC>l c` | Create TOC at cursor | Normal |
| `<SPC>l C` | Remove TOC | Normal |
| `<SPC>l u` | Update TOC | Normal |

### Code Blocks
| Keymap | Action | Mode |
|--------|--------|------|
| `<SPC>l r` | Run code in block | Normal |
| `<SPC>l f` | Format code block | Normal |

### Checkbox
| Keymap | Action | Mode |
|--------|--------|------|
| `<SPC>l t` | Toggle checkbox | Normal |

## 8.2 Go (SPC l)

### Navigation
| Keymap | Action | Mode |
|--------|--------|------|
| `<SPC>l a` | Go alternate (test/impl) | Normal |
| `<SPC>l g` | Go definition | Normal |
| `<SPC>l i` | Go implements | Normal |
| `<SPC>l l` | Decl in file | Normal |
| `<SPC>l L` | Decl in directory | Normal |

### Documentation
| Keymap | Action | Mode |
|--------|--------|------|
| `<SPC>l d` | Go doc | Normal |
| `<SPC>l D` | Go doc (vertical) | Normal |
| `<SPC>l h` | Go info | Normal |

### Build & Test
| Keymap | Action | Mode |
|--------|--------|------|
| `<SPC>l b` | Go build | Normal |
| `<SPC>l t` | Go test | Normal |
| `<SPC>l T` | Go test function | Normal |
| `<SPC>l r` | Execute current file | Normal |
| `<SPC>l c` | Go coverage toggle | Normal |

### Refactoring
| Keymap | Action | Mode |
|--------|--------|------|
| `<SPC>l e` | Go rename | Normal |
| `<SPC>l G` | Go generate | Normal |
| `<SPC>l I` | Impl stubs | Normal |
| `<SPC>l s` | Fill struct | Normal |
| `<SPC>l v` | Freevars | Normal |

### Tags & Imports
| Keymap | Action | Mode |
|--------|--------|------|
| `<SPC>l k` | Add tags | Normal |
| `<SPC>l K` | Remove tags | Normal |
| `<SPC>l m` | Format imports | Normal |
| `<SPC>l M` | Add import | Normal |

## 8.3 Ruby (SPC l)

### Execution
| Keymap | Action | Mode |
|--------|--------|------|
| `<SPC>l r` | Execute current file | Normal |

### Workspace
| Keymap | Action | Mode |
|--------|--------|------|
| `<SPC>l w l` | List workspace folders | Normal |
| `<SPC>l w a` | Add workspace folder | Normal |
| `<SPC>l w r` | Remove workspace folder | Normal |

### REPL
| Keymap | Action | Mode |
|--------|--------|------|
| `<SPC>l s i` | Start REPL process | Normal |
| `<SPC>l s l` | Send line to REPL | Normal |
| `<SPC>l s b` | Send buffer to REPL | Normal |
| `<SPC>l s s` | Send selection to REPL | Normal |

---

# 9. Snippets & Completion

## 9.1 NeoSnippet

### Snippet Expansion
| Keymap | Action | Mode |
|--------|--------|------|
| `<C-e>` | Expand or jump to next | Insert/Select |
| `<C-e>` | Expand snippet target | Visual |
| `<TAB>` | Jump to next (if expandable) | Select |

## 9.2 Copilot

### AI Completion
| Keymap | Action | Mode |
|--------|--------|------|
| `<C-J>` | Accept Copilot suggestion | Insert |

---

# 10. Quickfix & Errors

## 10.1 Quickfix Window

### Quickfix Control
| Keymap | Action | Mode |
|--------|--------|------|
| `,qc` | Close quickfix window | Normal |
| `,qo` | Open quickfix window | Normal |

### Error Navigation
| Keymap | Action | Mode |
|--------|--------|------|
| `<leader>n` | Next error | Normal |
| `<leader>p` | Previous error | Normal |

---

# 11. Vim Configuration

## 11.1 Config Files

### Edit Config
| Keymap | Action | Mode |
|--------|--------|------|
| `<leader>ev` | Edit .vimrc in new tab | Normal |
| `<leader>em` | Edit Makefile | Normal |
| `<leader>v` | Vertical split .vimrc | Normal |

### Reload Config
| Keymap | Action | Mode |
|--------|--------|------|
| `,vr` | Reload .vimrc | Normal |
| `<leader>V` | Source .vimrc | Normal |
| `<D-%>` / `<A-%>` | Source current file | Normal |

### Execute Vim Commands
| Keymap | Action | Mode |
|--------|--------|------|
| `,vc` | Execute line as vim command | Normal |

## 11.2 File Info

### Copy Filename
| Keymap | Action | Mode |
|--------|--------|------|
| `,cf` | Copy relative filename | Normal |
| `,cr` | Copy full filename | Normal |
| `,cn` | Copy filename only | Normal |

### Directory
| Keymap | Action | Mode |
|--------|--------|------|
| `<leader>cd` | Change CWD to buffer dir | Normal |

---

# 12. UI & Display

## 12.1 Display Options

### Paste Mode
| Keymap | Action | Mode |
|--------|--------|------|
| `<leader>pp` | Toggle paste mode | Normal |
| `<localleader>tp` | Toggle paste mode | Normal |

### Screen
| Keymap | Action | Mode |
|--------|--------|------|
| `<leader>l` | Redraw screen | Normal |
| `<leader>--` | Set cmdheight default | Normal |

### Spell Check
| Keymap | Action | Mode |
|--------|--------|------|
| `<leader>ss` | Toggle spell checking | Normal |

## 12.2 Debug

### Syntax Highlight
| Keymap | Action | Mode |
|--------|--------|------|
| `,hi` | Echo highlight group under cursor | Normal |

### Preview
| Keymap | Action | Mode |
|--------|--------|------|
| `,hp` | Preview HTML in Safari | Normal |

---

# 13. Miscellaneous

## 13.1 Saving

### Quick Save
| Keymap | Action | Mode |
|--------|--------|------|
| `<Leader>w` | Write file | Normal/Insert/Visual |
| `:W` | Sudo write file | Command |

## 13.2 Scratch Buffers

### Temporary Files
| Keymap | Action | Mode |
|--------|--------|------|
| `<leader>q` | Open ~/buffer for scribble | Normal |
| `<leader>x` | Open ~/buffer.md for markdown | Normal |

## 13.3 Special

### Text Cleanup
| Keymap | Action | Mode |
|--------|--------|------|
| `<leader>m` | Remove Windows ^M characters | Normal |

### JSON
| Keymap | Action | Mode |
|--------|--------|------|
| `<localleader>js` | Format JSON with python | Visual |

### Testing
| Keymap | Action | Mode |
|--------|--------|------|
| `,tt` | Toggle RSpec test :now flag | Normal |

---

# Appendix: Key Notation

| Notation | Key |
|----------|-----|
| `<SPC>` | Space bar |
| `<CR>` | Enter/Return |
| `<C-x>` | Ctrl + x |
| `<D-x>` | Cmd + x (Mac) |
| `<A-x>` | Alt + x (Linux) |
| `<leader>` | Leader key (usually `\`) |
| `<localleader>` | Local leader (usually `,`) |
