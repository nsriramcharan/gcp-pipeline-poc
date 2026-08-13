#!/usr/bin/env bash

ROOT_DIR="${1:-.}"

echo "Scanning: $ROOT_DIR"
echo

find "$ROOT_DIR" -type f -name "*.tf" -print |
while IFS= read -r file; do
    dirname "$file"
done | sort -u |
while IFS= read -r dir; do

    echo "Generating README.md for: $dir"

    terraform-docs markdown table \
        --output-file README.md \
        --output-mode replace \
        "$dir"

    if [ $? -eq 0 ]; then
        echo "  ✓ README.md created"
    else
        echo "  ✗ Failed: $dir"
    fi

    echo
done

echo "Documentation generation completed."
