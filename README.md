# fire

**Run, open, read or edit the thing an agent just handed you, without ever copying a path.**

You type at most eight characters. The agent does the typing of paths. That is the whole idea.

```
fire ls          what is queued (newest first, numbered)
fire             run the newest queued script
fire 3           run #3
fire show 3      read #3 in the terminal, numbered lines
fire edit 3      change #3 in nano, then `fire 3`
fire open 2      open #2 in its normal Mac app (doc, folder, URL)
fire path 2      put #2's exact path on the clipboard for another app
```

## Why this exists

Copying a path or a command out of a terminal is unreliable: wrapped lines, a trailing period from the
end of a sentence, a stray space, Mac paths with spaces that need quoting, a zoom level you can't read.
Kellen estimated more than an hour a day lost to exactly that. `fire` removes the copy step.
The agent queues the path; you refer to it by number.

## The contract

**Agent side.** Every time an agent makes something for you to run or look at, it:

1. runs `fire add <path> "<what it is>"`, and
2. still shows you, in the chat, the path, what the thing does in two or three lines, and the key lines
   (or the whole script if short), then says: **"queued; run `fire`"** (or `fire open`, etc).

You review before you run. You can read the whole queue back at night with `fire ls` and `fire show n`.

**Your side.** You type one of the commands above. Nothing else.

If an agent hands you a snippet with a placeholder in it, or a path to copy, it has broken the contract.
Say so. The rule lives in `~/.claude/CLAUDE.md` ("How to work with me") and in `AGENTS.md` here.

## A typical exchange

> **Agent:** Queued as `fire 1`: `~/ops/plans/2026-11-09-foo.sh`. It reads the Tailscale key from 1Password,
> validates the policy, and saves it. Dry run by default. Run `fire`; then `APPLY=1 fire` to apply.
>
> **You:** `fire show 1` … looks right … `fire` … output looks right … `APPLY=1 fire`
>
> **Agent:** Changed line 40 to also back up the search paths.
>
> **You:** `APPLY=1 fire` (same command; the file changed, not the command)

## Rules of thumb

- **`fire` runs whatever is newest.** It prints the path and note first. Read that line.
- **Scripts in `~/ops/plans/` are dry-run by default** and need `APPLY=1` to write. That convention is what
  makes a bare `fire` safe. `fire` adds no safety of its own.
- **Environment flags pass straight through:** `APPLY=1 SEARCH=1 fire 3`.
- **Not a script?** `fire 2` on a doc or folder just opens it.
- **Numbers shift** when something new is queued: #1 is always the newest. `fire ls` first if unsure.

## Editing

`fire edit n` opens nano. Save: `Ctrl+O`, `Enter`. Quit: `Ctrl+X`. Then `fire n` runs the edited file.
Prefer another editor: `FIRE_EDITOR=nvim fire edit 3` for one run, or `export FIRE_EDITOR=nvim` in your shell.

## Where things live

| What | Where |
|---|---|
| the command | `~/dev/fire/fire` (this repo), symlinked from `~/ops/bin/fire` (on PATH) |
| the queue | `~/ops/.fire/queue.tsv`, one line per entry: `epoch ⇥ path ⇥ note`. Plain text, safe to edit or delete. Override: `FIRE_QUEUE=…` |
| the rule for agents | `AGENTS.md` here, and `~/.claude/CLAUDE.md` |
| self-test | `./test.sh` |

The queue is **not** a secret store. Paths only. Never queue a token.

## Housekeeping

- `fire rm 3` drops one entry. `fire clear` empties the queue. Entries are never removed automatically.
- `fire version`, `fire help`.

## Troubleshooting

- **`zsh: correct 'fire' to 'file' [nyae]?`** Your shell has `correct_all`. `~/.zshrc` has
  `alias fire='nocorrect fire'` (added 2026-11-09). Open a new tab if you still see it.
- **`command not found: fire`** `~/ops/bin` must be on PATH (it is, via `~/.zshrc`). Check `ls -l ~/ops/bin/fire`
  points at `~/dev/fire/fire`.
- **`fire: no entry 4 (fire ls)`** Numbers moved. `fire ls`.
- **Path with spaces opens the wrong thing** Report it. The queue stores the path verbatim and every
  command quotes it; that would be a bug.

## Roadmap

See `CHANGELOG.md` for what exists. Ideas, roughly in order:

- `[easy]` `o` as a two-letter alias for `fire open`
- `[easy]` `fire ls` shows age ("3 min ago") and whether the file still exists
- `[easy]` agents open docs for you directly (`open <file>`) instead of queueing them
- `[med]` a Claude Code hook that refuses any agent-created path containing a space
- `[med]` `fire log`: what was run when, with exit code (append-only)
- `[med]` per-entry note of which machine it must run on (newton vs. a lab host)
- `[hard]` `fire` on a lab host: queue synced over the tailnet so the same numbers work everywhere
