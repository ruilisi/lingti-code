# Tmux Keymaps

Prefix key is `C-a` (Ctrl+A) — written as `PRE` below.

Press `PRE C-a` to send a literal `C-a` to the terminal.

---

## Session Management

| Keymap | Action |
|--------|--------|
| `PRE C-c` | Create new session |
| `PRE C-f` | Find/switch session by name |
| `PRE BTab` | Switch to last (previously used) session |

## Configuration

| Keymap | Action |
|--------|--------|
| `PRE e` | Open local config (`~/.tmux.conf.local`) in new window |
| `PRE r` | Reload tmux config |

---

## Pane Management

### Splitting

| Keymap | Action |
|--------|--------|
| `PRE -` | Split vertically (top / bottom) |
| `PRE _` | Split horizontally (left / right) |

### Navigation (vim-style, repeatable)

| Keymap | Action |
|--------|--------|
| `PRE h` | Move to left pane |
| `PRE j` | Move to pane below |
| `PRE k` | Move to pane above |
| `PRE l` | Move to right pane |

> **Note:** vim-tmux-navigator also enables `C-h / C-j / C-k / C-l` (no prefix) to navigate seamlessly between Vim splits and tmux panes.

### Resize (repeatable)

| Keymap | Action |
|--------|--------|
| `PRE H` | Resize pane left (2 cells) |
| `PRE J` | Resize pane down (2 cells) |
| `PRE K` | Resize pane up (2 cells) |
| `PRE L` | Resize pane right (2 cells) |

### Swap & Maximize

| Keymap | Action |
|--------|--------|
| `PRE >` | Swap current pane with next |
| `PRE <` | Swap current pane with previous |
| `PRE +` | Maximize / restore current pane |

### Other Pane Actions

| Keymap | Action |
|--------|--------|
| `PRE m` | Toggle mouse on / off |
| `PRE F` | Launch Facebook PathPicker (`fpp`) on pane content |

---

## Window Management

| Keymap | Action |
|--------|--------|
| `PRE Tab` | Switch to last active window |

---

## Copy Mode

Enter copy mode with `PRE Enter` (vi-style).

### Vi Copy Mode Bindings

| Keymap | Action |
|--------|--------|
| `v` | Begin selection |
| `C-v` | Toggle rectangle selection |
| `y` | Copy selection and exit copy mode |
| `H` | Jump to start of line |
| `L` | Jump to end of line |
| `Escape` | Cancel / exit copy mode |

---

## Buffer & Clipboard

| Keymap | Action |
|--------|--------|
| `PRE b` | List paste buffers |
| `PRE p` | Paste from top paste buffer |
| `PRE P` | Choose paste buffer interactively |

---

## Misc

| Keymap | Action |
|--------|--------|
| `C-l` | Clear screen and scroll history (no prefix needed) |
