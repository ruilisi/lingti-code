# bin/ Commands Reference

Utilities bundled in `~/.lingti/bin/` and available on `$PATH` after install.

---

## lingti

The main Lingti CLI. Uses git-style subcommands.

```bash
lingti <subcommand> [args]
```

| Subcommand | Description |
|---|---|
| `vim-add-plugin <user/repo>` | Add a Vim plugin (GitHub) |
| `vim-delete-plugin <name>` | Remove a Vim plugin |
| `vim-list-plugin` | List installed Vim plugins |
| `init-plugins` | Initialize all plugins |
| `update-plugins` | Update all plugins |

---

## mdserve

Markdown live-preview server with auto-reload on save.

```bash
mdserve                        # serve all .md in current dir on port 6419
mdserve README.md              # serve single file
mdserve README.md 8080         # custom port
mdserve /path/to/dir           # serve all .md in given directory
```

- Uses [marked](https://github.com/markedjs/marked) for rendering (auto-installed via npm on first run)
- Live-reloads the browser via SSE when files change
- Listens on `0.0.0.0` — accessible on local network

---

## ralph

Long-running AI agent loop. Reads `prd.json` and `prompt.md` from the current directory and runs an AI agent iteratively until it outputs `<promise>COMPLETE</promise>` or hits the iteration limit.

```bash
ralph                          # run with amp, up to 10 iterations
ralph 20                       # up to 20 iterations
ralph --tool claude            # use Claude Code instead of amp
ralph --tool amp 5             # amp, up to 5 iterations
```

State files (in current directory):
- `prd.json` — task spec read by the agent
- `prompt.md` — prompt passed to amp
- `progress.txt` — running log of iterations
- `archive/` — previous runs archived when branch changes

---

## yolo

Runs `claude --dangerously-skip-permissions`, bypassing all permission prompts.

```bash
yolo [claude args...]
```

---

## lint-js

Lint a JS/TS project using ESLint via bun.

```bash
lint-js              # lint current directory
lint-js /path/to/project
```

Prefers `bun run lint` if defined in `package.json`, falls back to `bunx eslint .`.

---

## lint-fix-js

Lint and auto-fix a JS/TS project using ESLint via bun.

```bash
lint-fix-js              # fix current directory
lint-fix-js /path/to/project
```

Prefers `bun run lint:fix`, then `bun run lint --fix`, then `bunx eslint . --fix`.

---

## html2img

Convert an HTML file to a PNG/JPG image using Puppeteer (captures full page height).

```bash
html2img input.html                    # output: input.png
html2img input.html output.png
html2img input.html -o output.png
html2img input.html --width 1200
html2img input.html --format jpg
```

Options:

| Flag | Default | Description |
|---|---|---|
| `-o, --output` | same dir as input | Output file path |
| `--width` | `1200` | Viewport width in px |
| `--format` | `png` | `png` or `jpg` |

---

## fasd

[Fasd](https://github.com/clvv/fasd) — frecency-based directory and file jumper. Tracks visited paths and lets you jump with fuzzy matching.

```bash
fasd [options] [query ...]
```

Typical aliases set up via `fasd --init`:

| Alias | Description |
|---|---|
| `z <query>` | Jump to frecent directory |
| `v <query>` | Open frecent file in `$EDITOR` |
| `o <query>` | Open frecent file with `xdg-open` / `open` |

---

## marky.rb

Convert a URL or HTML file to Markdown using the [Heck Yes Markdown](http://heckyesmarkdown.com) service.

```bash
marky.rb -f html input.html
marky.rb -f url http://example.com
marky.rb -o /output/dir -f url http://example.com
```

Options: `-o DIR` (output folder), `-f TYPE` (input type: `html`, `url`), `-t TYPE` (output type).

---

## macos

Apply opinionated macOS system defaults (menu bar, scrollbars, Finder, Dock, etc.). Based on [@mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles).

```bash
bash ~/.lingti/bin/macos
```

Run once after a fresh macOS install. Most settings require a logout/restart to take effect.

---

## rebuild_mail_index.sh

Rebuild the macOS Mail app's SQLite Envelope Index — useful when Mail is slow or search is broken.

```bash
bash ~/.lingti/bin/rebuild_mail_index.sh
```

Kills Mail, vacuums the SQLite index, and reopens Mail. Reports index size before/after.

---

## fix_macvim_external_display.sh

Fix MacVim window-position corruption when switching external displays by deleting its preference files.

```bash
bash ~/.lingti/bin/fix_macvim_external_display.sh
```

You may need to restart macOS after running this.

---

## jsl

JavaScript linter binary (JSL). Used internally or directly:

```bash
jsl [options] file.js
```
