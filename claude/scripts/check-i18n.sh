#!/usr/bin/env bash
# check-i18n.sh
# Detects incomplete i18n translations in the current project.
# Called as a PostToolUse hook after Edit/Write tool calls.
# Outputs missing keys so Claude can complete them.

set -uo pipefail

CWD="${PWD}"

# Find locale directories (common i18n patterns), skip build/dep dirs
find_locale_dirs() {
    find "$1" -maxdepth 6 -type d \( \
        -name "locales" -o -name "translations" -o \
        -name "i18n"    -o -name "locale" \
    \) \
    ! -path "*/node_modules/*" \
    ! -path "*/.next/*" \
    ! -path "*/dist/*" \
    ! -path "*/.git/*" \
    ! -path "*/build/*" \
    ! -path "*/.cache/*" \
    2>/dev/null | head -10
}

# Flatten JSON keys to dot-notation leaf paths using jq
json_leaf_keys() {
    jq -r '[paths(scalars)] | map(join(".")) | .[]' "$1" 2>/dev/null
}

# Check one locale directory for missing keys
check_locale_dir() {
    local locale_dir="$1"
    local missing_output=""

    # Collect locale subdirs (en, zh, fr, ...)
    local locales=()
    while IFS= read -r d; do
        locales+=("$(basename "$d")")
    done < <(find "$locale_dir" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort)

    [[ ${#locales[@]} -lt 2 ]] && return

    # Treat the first locale (alphabetically) as reference
    local ref="${locales[0]}"

    for ref_file in "$locale_dir/$ref"/*.json; do
        [[ -f "$ref_file" ]] || continue
        local fname
        fname="$(basename "$ref_file")"

        local ref_keys
        ref_keys=$(json_leaf_keys "$ref_file")
        [[ -z "$ref_keys" ]] && continue

        for locale in "${locales[@]}"; do
            [[ "$locale" == "$ref" ]] && continue
            local target="$locale_dir/$locale/$fname"

            if [[ ! -f "$target" ]]; then
                missing_output+="  • Missing file: $locale/$fname\n"
                continue
            fi

            local target_keys
            target_keys=$(json_leaf_keys "$target")

            local missing
            missing=$(comm -23 \
                <(echo "$ref_keys" | sort) \
                <(echo "$target_keys" | sort))

            if [[ -n "$missing" ]]; then
                while IFS= read -r key; do
                    local ref_value
                    ref_value=$(jq -r --arg k "$key" 'getpath($k | split(".")) // ""' "$ref_file" 2>/dev/null)
                    missing_output+="  • $locale/$fname: \"$key\" (${ref}: \"$ref_value\")\n"
                done <<< "$missing"
            fi
        done
    done

    if [[ -n "$missing_output" ]]; then
        echo "i18n: missing translations found in $(realpath --relative-to="$CWD" "$locale_dir" 2>/dev/null || echo "$locale_dir"):"
        echo -e "$missing_output"
    fi
}

# Require jq
if ! command -v jq &>/dev/null; then
    exit 0
fi

found_any=false
while IFS= read -r locale_dir; do
    result=$(check_locale_dir "$locale_dir")
    if [[ -n "$result" ]]; then
        found_any=true
        echo "$result"
    fi
done < <(find_locale_dirs "$CWD")

if [[ "$found_any" == true ]]; then
    echo "Please add the missing translation keys to complete i18n coverage."
fi

exit 0
