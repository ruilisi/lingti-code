# Tmux Keymaps

Prefix is defined as `C-a` (`PRE` for short)

## Pane Management

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

## Window Management

### Window Actions
| Keymap | Action | Mode |
|--------|--------|------|
| `PRE ,` | Rename window | Tmux |
| `PRE d` | Detach from session | Tmux |
| `PRE D` | Choose session to detach | Tmux |
| `PRE >` | Show cheatsheet | Tmux |
| `PRE <` | Show cheatsheet | Tmux |

## Copy Mode

Press `PRE [` to enter Scroll/Copy Mode

### Copy Mode Operations
| Keymap | Action | Mode |
|--------|--------|------|
| `Shift-V` | Select text (visual line) | Copy Mode |
| `Enter` | Copy selected text | Copy Mode |
| `]` | Paste text copied from scroll mode | Normal |
