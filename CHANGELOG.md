# Changelog

## 0.2.0 — 2026-11-09
- `fire show n` (bat, numbered), `fire edit n` (nano; `FIRE_EDITOR` override), `fire version`.
- Bare `fire n` on a non-script opens it instead of erroring.
- `FIRE_QUEUE` env override; repo at `~/dev/fire`, `~/ops/bin/fire` is a symlink.
- README, AGENTS.md (agent contract), test.sh.

## 0.1.0 — 2026-11-09
- First version, written in session after Kellen described losing >1 h/day to copying paths and
  commands out of the terminal. `fire`, `fire ls`, `fire N`, `fire open`, `fire path`, `fire add`,
  `fire rm`, `fire clear`. Env passthrough. Queue at `~/ops/.fire/queue.tsv`.
- `~/.zshrc`: `alias fire='nocorrect fire'` (zsh `correct_all` offered `file`).
