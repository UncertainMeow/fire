# AGENTS.md — the contract for any agent handing Kellen something to run or read

Kellen never copies a path or a command from a terminal. You do the path handling.

1. **Queue it:** `fire add <absolute-path-or-url> "<what it is, ≤ 10 words>"` — `~/ops/bin/fire` is on PATH.
2. **Still show it in chat:** the path, what it does in 2–3 lines, the key lines (whole script if short).
   He reviews before running and reads sessions back at night. Then say: *"queued; run `fire`"* (or
   `fire open`, `fire show`, `APPLY=1 fire` — whatever applies).
3. **Never** paste a snippet with a placeholder (`<TOKEN>`, "put your key here"). Scripts fetch their own
   secrets at runtime (1Password / OP Connect). If a secret is missing, the script aborts naming the
   1Password item to create; the command Kellen runs does not change.
4. **Never** create a path with a space in it. Date-first names: `YYYY-MM-DD-topic`.
5. **Dry run by default**, `APPLY=1` to write. A bare `fire` must be safe.
6. If the command changes (not just the file), say so: "the command is now `APPLY=1 SEARCH=1 fire`".
7. Multi-line text he must paste into another app (a web console, a form): `pbcopy < file` and say
   "it's on your clipboard". Not chat.

Queue file: `~/ops/.fire/queue.tsv`. Paths only. Never a token.
