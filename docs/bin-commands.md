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

## html2pdf

Convert an HTML file to PDF via headless Chrome. **Designed around the
"中文渲染成方块" failure mode** — looks fine on screen but the PDF is full
of empty squares because macOS system fonts (e.g. `PingFang SC`) aren't
always usable from headless Chrome.

```bash
html2pdf input.html                      # → input.pdf
html2pdf input.html out.pdf              # explicit output
html2pdf input.html -o out.pdf --open    # open after generation
html2pdf input.html --paper a4 --landscape
html2pdf input.html --budget 20000       # slow webfonts? extend
html2pdf input.html --no-verify          # English-only HTML
```

### Options

| Flag | Default | Description |
|---|---|---|
| `-o, --output` | `<input>.pdf` | Output file path |
| `--budget` | `15000` | Virtual time budget in ms (let webfonts download) |
| `--paper` | `letter` | `letter` \| `a4` \| `a3` |
| `--landscape` | off | Landscape orientation |
| `--header-footer` | off | Keep Chrome's default date/URL header & footer |
| `--no-verify` | off | Skip the CJK-rendering check |
| `--open` | off | `open` the PDF after generation |

### What it does for you (all baked in)

| Concern | How `html2pdf` handles it |
|---|---|
| Chrome path | Looks up `/Applications/Google Chrome.app/Contents/MacOS/Google Chrome`; aborts cleanly if missing |
| Header/footer | `--no-pdf-header-footer` by default (opt-in with `--header-footer`) |
| Webfont loading | `--virtual-time-budget=15000` (extend with `--budget`) + `--run-all-compositor-stages-before-draw` |
| Relative paths | Resolves input to absolute path and builds the `file://` URL |
| Silent failures | After generation, runs `pdftotext` on page 1; if the HTML contained CJK but the PDF page 1 doesn't, exits **2** with a remediation hint |

### Required HTML for Chinese output

The verifier catches mistakes, but you have to author the HTML right too.
Per project convention, every Chinese HTML destined for PDF must:

1. **Load Noto SC webfonts in `<head>`:**
   ```html
   <link rel="preconnect" href="https://fonts.googleapis.com">
   <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
   <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+SC:wght@300;400;500;700;900&family=Noto+Serif+SC:wght@500;700;900&display=swap" rel="stylesheet">
   ```
2. **Put Noto fonts first in `font-family`:**
   ```css
   font-family: "Noto Sans SC", "PingFang SC", "Microsoft YaHei", sans-serif;
   ```
   `PingFang SC` / `Microsoft YaHei` are fallback-only — never first.

If verification still fails, bump `--budget` (slow networks) or check
your `<link>` URLs.

### Exit codes

| Code | Meaning |
|---|---|
| `0` | PDF generated and (when applicable) CJK verified |
| `1` | Usage error / Chrome missing / input not found / PDF not produced |
| `2` | PDF produced but CJK rendering check failed |

### Dependencies

- Google Chrome (mandatory)
- `pdftotext` from `poppler` for verification (`brew install poppler`).
  Without it, generation still works but you get a warning instead of a check.

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

---

## chrome-mcp

Launch Chrome with a **named, isolated profile** plus a remote debugging
port. Profiles live in `~/.lingti/chrome-profiles/<name>` — each gets its
own cookies, logins, and extensions; first run is a fresh Chrome, sign in
once and credentials persist.

```bash
chrome-mcp work                # launch profile 'work' on first free 9222+ port
chrome-mcp personal            # second profile, different port
chrome-mcp --list              # show all known profiles
```

The remote-debugging port is auto-picked starting at 9222 and increments
until it finds a free one — multiple profiles can run side-by-side and
each gets its own CDP endpoint. Pair with `chrome-cdp` for scripted
control.

---

## chrome-cdp

Talk to a running `chrome-mcp` Chrome over its CDP HTTP endpoints. Useful
for quick scripting, automation hooks, or recipes that don't warrant a
Puppeteer setup.

```bash
chrome-cdp ps                          # scan 9222-9229, show live ports
chrome-cdp tabs [port]                 # list open tabs on a port
chrome-cdp open <url> [port]           # open new tab
chrome-cdp activate <tab-id> [port]    # focus a tab
chrome-cdp close <tab-id> [port]       # close a tab
chrome-cdp eval <tab-id> '<js>' [port] # Runtime.evaluate in a tab
chrome-cdp version [port]              # print /json/version
```

- Default port: `9222`
- Trailing numeric arg is always treated as a port — no need for a flag
- `chrome-cdp ps` is the easiest way to recover the port for a profile
  you launched earlier

---

## yt-share

Download a YouTube video with `yt-dlp`, then re-encode to a "share-friendly"
MP4 (works for WeChat / Telegram / iMessage attachments).

```bash
yt-share <YouTube-URL>                # → ~/Downloads/<title>_share.mp4
yt-share <YouTube-URL> /path/to/dir   # custom output directory
```

Picks best video + audio, transcodes to a widely-compatible profile, and
sanitizes the filename. Requires `yt-dlp` and `ffmpeg` on `$PATH`.
