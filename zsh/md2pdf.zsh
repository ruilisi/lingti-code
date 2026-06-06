# Convert Markdown to PDF via Chrome headless (better table support)
md2pdf() {
  if [[ -z "$1" ]]; then
    echo "Usage: md2pdf <file.md> [output.pdf]"
    return 1
  fi
  local input="$1"
  local output="${2:-${input%.md}.pdf}"
  local tmpdir=$(mktemp -d -t md2pdf)
  local tmphtml="$tmpdir/index.html"

  pandoc "$input" -o "$tmphtml" --standalone \
    --metadata title="" \
    --highlight-style=tango \
    --embed-resources \
    --mathjax \
    -H <(cat <<'CSS'
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+SC:wght@300;400;500;700;900&family=Noto+Serif+SC:wght@500;600;700;900&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
  body { font-family: "Noto Sans SC", "PingFang SC", "Heiti SC", "Microsoft YaHei", "Helvetica Neue", sans-serif; font-size: 14px; line-height: 1.6; max-width: 860px; margin: 40px auto; padding: 0 40px; color: #222; }
  h1,h2,h3,h4 { font-family: "Noto Serif SC", "Source Han Serif SC", "Songti SC", serif; color: #111; margin-top: 1.4em; }
  table { border-collapse: collapse; width: 100%; margin: 1em 0; font-size: 13px; }
  th { background: #f0f0f0; font-weight: bold; }
  th, td { border: 1px solid #ccc; padding: 8px 12px; text-align: left; }
  tr:nth-child(even) { background: #fafafa; }
  code { font-family: "JetBrains Mono", "SFMono-Regular", Consolas, monospace; background: #f5f5f5; padding: 2px 5px; border-radius: 3px; font-size: 12px; }
  pre { font-family: "JetBrains Mono", "SFMono-Regular", Consolas, monospace; background: #f5f5f5; padding: 12px; border-radius: 4px; overflow-x: auto; }
  blockquote { border-left: 4px solid #ccc; margin: 0; padding-left: 1em; color: #555; }
</style>
CSS
) && \
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
    --headless=new --disable-gpu --no-sandbox \
    --no-pdf-header-footer \
    --run-all-compositor-stages-before-draw \
    --virtual-time-budget=20000 \
    --print-to-pdf="$output" \
    "file://$tmphtml" 2>/dev/null

  rm -rf "$tmpdir"
  [[ -f "$output" ]] && echo "Created $output" || { echo "Failed to create $output"; return 1; }
}
