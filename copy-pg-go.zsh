#!/usr/bin/env zsh
set -euo pipefail

BBIN=$(bazel info bazel-bin)
EXEC=$(bazel info execution_root)

copy_tree() {
  local ROOT="$1"
  find "$ROOT" -type f -name '*.pb.go' -path '*/pkg/*' ! -path '*/external/*' | \
  while IFS= read -r SRC; do
    REL="pkg/${SRC#*/pkg/}"
    DEST_DIR="${REL:h}"
    mkdir -p "$DEST_DIR"
    cp -f "$SRC" "$DEST_DIR/"
    echo "copied -> $DEST_DIR/${REL:t}"
  done
}

copy_tree "$EXEC"
copy_tree "$BBIN"
echo "done"

