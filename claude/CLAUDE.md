# Global Claude Code Instructions

## Git Commits

When creating git commits, do not include the "Co-Authored-By: Claude" line in commit messages.

## Go Code Style

Always use the modern Go 1.22+ range-over-integer syntax for counting loops:
- `for i := range n {` instead of `for i := 0; i < n; i++ {`
- `for range n {` when the loop variable is unused

## Vim Keymaps

### Search

| Key | Action |
|-----|--------|
| `*` | Search forward for word under cursor |
| `#` | Search backward for word under cursor |
| `g*` | Search forward (partial match) |
| `g#` | Search backward (partial match) |
| `SPC s p` | Search in project |
| `SPC s P` | Search word under cursor in project |

### Go to Definition

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Go to references |

