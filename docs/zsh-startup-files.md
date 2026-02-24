# ZSH Startup Files

This document explains which zsh configuration files are loaded and in what order.

## Prezto Runcoms

The files in `zsh/prezto/runcoms/` are symlinked to `~/` with a `.` prefix during installation.

| File | Symlinked To |
|------|--------------|
| `zshenv` | `~/.zshenv` |
| `zprofile` | `~/.zprofile` |
| `zshrc` | `~/.zshrc` |
| `zlogin` | `~/.zlogin` |
| `zlogout` | `~/.zlogout` |
| `zpreztorc` | `~/.zpreztorc` |

## Load Order by Shell Type

### Non-interactive Shell

Commands like `docker run image command` or `ssh host command`:

```
zshenv
```

### Interactive Non-login Shell

Commands like `docker exec -it container zsh` or opening a new terminal tab:

```
zshenv → zshrc
```

### Interactive Login Shell

Commands like `docker run -it image zsh -l` or SSH login:

```
zshenv → zprofile → zshrc → zlogin
```

### On Logout (Login Shells Only)

```
zlogout
```

## File Purposes

| File | Purpose |
|------|---------|
| `zshenv` | Environment variables. Sourced for ALL shells. Keep minimal. |
| `zprofile` | Login shell setup. Runs before `zshrc`. Sets PATH, EDITOR, etc. |
| `zshrc` | Interactive shell config. Aliases, functions, prompt, completions. |
| `zlogin` | Runs after `zshrc` for login shells. Rarely needed. |
| `zlogout` | Cleanup on logout. Rarely needed. |
| `zpreztorc` | Prezto-specific configuration. Modules, themes, options. |

## Overriding Prezto Defaults

Custom overrides go in `zsh/prezto-override/`. These are symlinked after the base runcoms, replacing them:

```
zsh/prezto-override/zpreztorc  → ~/.zpreztorc
zsh/prezto-override/zshrc      → ~/.zshrc
zsh/prezto-override/zprofile   → ~/.zprofile  (if exists)
```

## User Customization Directories

For per-machine customizations without modifying the repo:

| Directory | Load Timing |
|-----------|-------------|
| `~/.zsh.before/` | Before Lingti configs |
| `~/.zsh.after/` | After Lingti configs |
| `~/.zsh.prompts/` | Custom prompt themes |

## Platform-Specific Files

Files with platform suffixes are only loaded on that OS:

- `*-darwin.zsh` - macOS only
- `*-linux.zsh` - Linux only

## Conditional Tool Setup

When adding tool-specific setup (Homebrew, Cargo, etc.), always check for existence:

```zsh
# Good - checks before sourcing
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# Good - checks before eval
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Bad - fails if not installed
. "$HOME/.cargo/env"
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## Docker Considerations

In Docker containers:

1. Base images often start non-login shells, only loading `zshenv`
2. Use `zsh -l` or configure the container to use login shells if you need full setup
3. Tools like Homebrew are typically not present - always use existence checks
