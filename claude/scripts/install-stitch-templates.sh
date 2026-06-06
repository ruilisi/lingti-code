#!/usr/bin/env bash
# install-stitch-templates.sh — refresh DESIGN.md + AGENTS.md templates
#
# Usage:
#   install-stitch-templates.sh                          # refresh ~/.claude/templates/
#   install-stitch-templates.sh --project <path>         # also copy into <path>/{DESIGN.md,AGENTS.md}
#   install-stitch-templates.sh --project <path> --variant atmospheric-glass
#                                                       # copy a specific DESIGN example
#
# Variants (DESIGN.md): atmospheric-glass | paws-and-paths | totality-festival
# Default variant: atmospheric-glass
#
# Idempotent: always fetches the latest from upstream.
# Requires: gh (GitHub CLI, authenticated), base64.

set -euo pipefail

TEMPLATES_DIR="${HOME}/.claude/templates"
PROJECT_DIR=""
VARIANT="atmospheric-glass"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)  PROJECT_DIR="$2"; shift 2 ;;
    --variant)  VARIANT="$2"; shift 2 ;;
    -h|--help)
      grep '^#' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
done

case "$VARIANT" in
  atmospheric-glass|paws-and-paths|totality-festival) ;;
  *) echo "unknown --variant: $VARIANT (expected: atmospheric-glass|paws-and-paths|totality-festival)" >&2; exit 2 ;;
esac

mkdir -p "$TEMPLATES_DIR"

fetch() {
  local repo="$1" path="$2" dest="$3"
  printf '  fetching %s ... ' "$path"
  if gh api "repos/${repo}/contents/${path}" --jq '.content' | base64 -d > "${dest}.tmp" 2>/dev/null; then
    mv "${dest}.tmp" "${dest}"
    printf 'ok (%d lines)\n' "$(wc -l < "${dest}")"
  else
    rm -f "${dest}.tmp"
    printf 'FAILED\n'
    return 1
  fi
}

echo "→ refreshing templates in ${TEMPLATES_DIR}"

# Google Stitch DESIGN.md
fetch google-labs-code/design.md "docs/spec.md"                            "${TEMPLATES_DIR}/DESIGN-spec.md"
fetch google-labs-code/design.md "examples/atmospheric-glass/DESIGN.md"    "${TEMPLATES_DIR}/DESIGN-atmospheric-glass.md"
fetch google-labs-code/design.md "examples/paws-and-paths/DESIGN.md"       "${TEMPLATES_DIR}/DESIGN-paws-and-paths.md"
fetch google-labs-code/design.md "examples/totality-festival/DESIGN.md"    "${TEMPLATES_DIR}/DESIGN-totality-festival.md"

# AGENTS.md open standard
fetch openai/agents.md           "AGENTS.md"   "${TEMPLATES_DIR}/AGENTS-openai-canonical.md"
fetch openai/agents.md           "README.md"   "${TEMPLATES_DIR}/AGENTS-spec-README.md"

echo "✓ templates refreshed"

if [[ -n "$PROJECT_DIR" ]]; then
  if [[ ! -d "$PROJECT_DIR" ]]; then
    echo "✗ project dir does not exist: $PROJECT_DIR" >&2
    exit 1
  fi
  echo "→ installing into project: ${PROJECT_DIR}"
  for f in DESIGN.md AGENTS.md; do
    if [[ -f "${PROJECT_DIR}/${f}" ]]; then
      echo "  ${f}: already exists, leaving alone (delete it first to re-install)"
      continue
    fi
  done
  if [[ ! -f "${PROJECT_DIR}/DESIGN.md" ]]; then
    cp "${TEMPLATES_DIR}/DESIGN-${VARIANT}.md" "${PROJECT_DIR}/DESIGN.md"
    echo "  ✓ ${PROJECT_DIR}/DESIGN.md  (variant: ${VARIANT})"
  fi
  if [[ ! -f "${PROJECT_DIR}/AGENTS.md" ]]; then
    cp "${TEMPLATES_DIR}/AGENTS-openai-canonical.md" "${PROJECT_DIR}/AGENTS.md"
    echo "  ✓ ${PROJECT_DIR}/AGENTS.md"
  fi
  echo "✓ done. Edit both files to match your project."
fi
