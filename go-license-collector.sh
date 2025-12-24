#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(pwd)"
LICENSE_DIR="$ROOT_DIR/LICENSES"

mkdir -p "$LICENSE_DIR"

echo "Downloading modules (if needed)…"
go mod download

echo "Collecting licenses…"

go list -m -f '{{.Path}} {{.Dir}}' all | while read -r MOD_PATH MOD_DIR; do
  if [[ "$MOD_DIR" == "$ROOT_DIR" ]]; then
    continue
  fi

  LICENSE_FILE=""
  for name in LICENSE LICENSE.txt LICENSE.md COPYING COPYING.txt; do
    if [[ -f "$MOD_DIR/$name" ]]; then
      LICENSE_FILE="$MOD_DIR/$name"
      break
    fi
  done

  if [[ -z "$LICENSE_FILE" ]]; then
    echo "⚠️  No license found for $MOD_PATH"
    continue
  fi

  DEST_DIR="$LICENSE_DIR/$MOD_PATH"
  mkdir -p "$DEST_DIR"
  cp "$LICENSE_FILE" "$DEST_DIR/"

  echo "✓ $MOD_PATH"
done
