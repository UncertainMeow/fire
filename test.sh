#!/usr/bin/env bash
# Self-test for fire. Uses a throwaway queue; never touches ~/ops/.fire. Run: ./test.sh
set -euo pipefail
here="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
qdir="$(mktemp -d)"; export FIRE_QUEUE="$qdir/queue.tsv"
F="$here/fire"; pass=0; fail=0
ok()   { pass=$((pass+1)); echo "ok   $1"; }
bad()  { fail=$((fail+1)); echo "FAIL $1"; }
tmp="$(mktemp -d)"; mkdir -p "$tmp/dir with space"
printf '#!/usr/bin/env bash\necho "ran with APPLY=${APPLY:-unset}"\n' > "$tmp/dir with space/s.sh"
echo "doc" > "$tmp/dir with space/a doc.md"

[ "$("$F" ls)" = "fire: queue is empty" ] && ok "empty queue message" || bad "empty queue message"
"$F" add "$tmp/dir with space/a doc.md" "a doc" >/dev/null
"$F" add "$tmp/dir with space/s.sh" "a script" >/dev/null
[ "$("$F" ls | wc -l | tr -d ' ')" = "2" ] && ok "two entries listed" || bad "two entries listed"
"$F" ls | sed -n 1p | grep -q "s.sh" && ok "newest is #1" || bad "newest is #1"
out="$("$F" 2>&1)"; grep -q "ran with APPLY=unset" <<<"$out" && ok "bare fire runs newest script (spaces in path)" || bad "bare fire runs newest: $out"
out="$(APPLY=1 "$F" 1 2>&1)"; grep -q "APPLY=1" <<<"$out" && ok "env passes through" || bad "env passthrough: $out"
"$F" path 2 >/dev/null; [ "$(pbpaste)" = "$tmp/dir with space/a doc.md" ] && ok "fire path copies exact path, no newline" || bad "fire path"
"$F" show 2 | grep -q "^── " && ok "fire show prints header" || bad "fire show"
"$F" rm 1 >/dev/null; "$F" ls | sed -n 1p | grep -q "a doc.md" && ok "fire rm renumbers" || bad "fire rm"
"$F" clear >/dev/null; [ "$("$F" ls)" = "fire: queue is empty" ] && ok "fire clear" || bad "fire clear"
"$F" bogus >/dev/null 2>&1 && bad "unknown command should fail" || ok "unknown command exits non-zero"
command rm -r -- "$tmp" "$qdir"
echo "----"; echo "$pass passed, $fail failed"; [ "$fail" = 0 ]
