#!/usr/bin/env bash
# Install fire for the current user. Idempotent. Run from a clone: ./install.sh
set -euo pipefail
here="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
bin="${FIRE_BIN_DIR:-$HOME/.local/bin}"; mkdir -p "$bin"
ln -sf "$here/fire" "$bin/fire"; chmod +x "$here/fire" "$here/test.sh" "$here/.githooks/pre-commit"
git -C "$here" config core.hooksPath .githooks        # secret guard on every commit in this clone
case ":$PATH:" in *":$bin:"*) ;; *) echo "NOTE: add to your shell rc:  export PATH=\"$bin:\$PATH\"" ;; esac
if [ -n "${ZSH_VERSION:-}" ] || [ "$(basename "${SHELL:-}")" = zsh ]; then
  echo "NOTE (zsh with correct_all): add   alias fire='nocorrect fire'   to ~/.zshrc, or zsh will offer to 'correct' fire to file."
fi
echo "installed: $bin/fire -> $here/fire"; "$bin/fire" version
