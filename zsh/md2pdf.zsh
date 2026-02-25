# Convert Markdown to PDF using pandoc + xelatex (supports CJK)
md2pdf() {
  if [[ -z "$1" ]]; then
    echo "Usage: md2pdf <file.md> [output.pdf]"
    return 1
  fi
  local input="$1"
  local output="${2:-${input%.md}.pdf}"
  pandoc "$input" -o "$output" \
    --pdf-engine=xelatex \
    -V CJKmainfont="Heiti SC" \
    -V geometry:margin=1in \
    -V fontsize=12pt \
    && echo "Created $output"
}
