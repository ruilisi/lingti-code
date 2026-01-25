# Global Claude Code Instructions

## Git Commits

When creating git commits, do not include the "Co-Authored-By: Claude" line in commit messages.

## Go Code Style

Always use the modern Go 1.22+ range-over-integer syntax for counting loops:
- `for i := range n {` instead of `for i := 0; i < n; i++ {`
- `for range n {` when the loop variable is unused
