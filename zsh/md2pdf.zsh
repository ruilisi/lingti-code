# Convert Markdown to PDF via Chrome headless (better table support)
#
# Usage:
#   md2pdf file.md                       # → file.pdf
#   md2pdf file.md output.pdf            # → output.pdf  (single-file, custom name)
#   md2pdf a.md b.md c.md                # → a.pdf b.pdf c.pdf
#   md2pdf *.md                          # → glob expansion, each → <basename>.pdf

_md2pdf_one() {
  local input="$1"
  local output="$2"
  local tmpdir=$(mktemp -d -t md2pdf)
  local tmphtml="$tmpdir/index.html"

  # 图片等相对路径按 **md 文件自己的目录** 解析（再兜一个当前目录）。
  # 没有这一行时，只有站在 md 所在目录跑才找得到图；在仓库根目录跑就全是
  # 「Could not fetch resource 附件/xxx.png」，而且 PDF 照样生成，图却是空的。
  pandoc "$input" -o "$tmphtml" --standalone \
    --resource-path="$(cd "$(dirname "$input")" && pwd):$PWD" \
    --metadata title="" \
    --highlight-style=tango \
    --embed-resources \
    --mathjax \
    -H <(cat <<'CSS'
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
  if [[ -f "$output" ]]; then
    echo "✅ $input → $output"
    return 0
  else
    echo "❌ Failed: $input"
    return 1
  fi
}

md2pdf() {
  if [[ -z "$1" ]]; then
    echo "Usage:"
    echo "  md2pdf <file.md>                     # → <file>.pdf"
    echo "  md2pdf <file.md> <output.pdf>        # single-file, custom output name"
    echo "  md2pdf <a.md> <b.md> <c.md> ...      # batch: each → <basename>.pdf"
    return 1
  fi

  # Backward-compat single-file mode: md2pdf input.md custom-name.pdf
  if [[ $# -eq 2 && "$2" != *.md && "$2" == *.pdf ]]; then
    if [[ ! -f "$1" ]]; then
      echo "❌ Not found: $1"
      return 1
    fi
    _md2pdf_one "$1" "$2"
    return $?
  fi

  # Batch mode: each arg is a .md file → corresponding .pdf
  local rc=0 count=0 fail=0
  for input in "$@"; do
    if [[ ! -f "$input" ]]; then
      echo "❌ Not found: $input"
      fail=$((fail + 1))
      rc=1
      continue
    fi
    _md2pdf_one "$input" "${input%.md}.pdf" || { rc=1; fail=$((fail + 1)); }
    count=$((count + 1))
  done
  if [[ $count -gt 1 ]]; then
    echo "── $((count - fail))/$count converted ──"
  fi
  return $rc
}
