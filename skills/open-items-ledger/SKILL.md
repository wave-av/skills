---
name: open-items-ledger
description: >-
  Use when work spans many sessions or several assistants and nothing left
  unresolved may be lost, at session start (read the first-prompt list), during
  a session (record open threads), at session end (write the note), and in any
  recurring triage loop or weekly review of open items.
---
# Open-items ledger

A standing list of every unresolved thread: questions, blanks, decisions waiting on someone, gaps, errors, interrupted work and learnings. Each session starts from the top of the list instead of from memory. Each session ends by writing down what it leaves open. A recurring loop settles items until each one is ticketed, acted on, or waiting on one specific thing.

## Layout (relative to the ledger folder)

| Path | Role |
|---|---|
| `harvest.sh` / `harvest.py` | Collects items from every source, dedupes, scores, applies verdicts, renders. Idempotent and lock-protected. Read-only toward the tracker. |
| `items.json` | State: every item ever seen, keyed by a stable id. Generated; never hand-edit. |
| `open-items.md` | Generated view: first-prompt candidates, triggers, stale items, all open items, resolved items. |
| `inbox/<agent>-<YYYY-MM-DD>.md` | Session-end notes, one per assistant per day. |
| `session-note.sh` / `validate-note.sh` / `notes.py` | Note writer, validator, parser. |
| `add-item.sh` | Add, resolve (`--resolve <id> "<verdict>" [ticket]`) or mark a trigger fired (`--fired <id> "<run ref>"`). |
| `verdicts/<id>.md` | One adversarial verdict per item. Header lines `status / waiting_on / next / verdict / ticket / trigger / fired` override harvested values. |
| `verdict-template.md` | The adversarial template. |
| `weekly/<YYYY-Www>.md` | Weekly rollup. |

## Item model

- **type:** question, blank, decision, gap, error, interrupt, learning.
- **status:** open, acting (owner running it), waiting-on (one specific reason), resolved.
- **id:** a hash of source and normalized text. Tracker-sourced items are keyed by ticket id and counters by source alone, so edits keep the id.
- **fields:** `waiting_on`, `links`, `trigger` (the unattended run that resolving this unblocks), `ticket`, `acted`, `close_check`, `last_moved`, `stale_days`, `sessions`, `reopen_count`, `score`.
- **score:** age `1+log2(1+days)` × severity (3 = security, production, secrets, money or exposure; 2 = decision, error or interrupt; 1 = other) × 2 if it unblocks something × corroboration (+25% per extra source, up to 4).

## Note format (v1)

```
<!-- open-items-note v1 -->
# Session note · <agent> · <YYYY-MM-DD>

## <time> session end
- [<type>] <text> | source: <session or turn> | waiting_on: <who + what> | links: <ticket, URL, repo#N, path> | trigger: <run it unblocks>
- [resolve] <item id or exact earlier text> | ticket: <ID> | acted: <what was done> | verdict: <one sentence>
```
Rules: `decision` needs `waiting_on`. `resolve` needs `ticket` or `acted`. Write `\|` for a literal pipe. Never put a secret value in a note; describe it instead.

## 1. Session start
1. Run nothing. Read `open-items.md` › **First-prompt candidates**, in this order:
   - **Ready to fire:** resolved items whose unattended run hasn't been confirmed. Launch the run, then `add-item.sh --fired <id> "<run ref>"`.
   - **Stale escalation:** open for 3+ days with no movement. Each one gets a verdict that moves it this session.
   - **Close-check:** resolved without a ticket or action record. Attach the ticket or reopen the item.
   - **Top open items** by score.
2. Take the items you own or can settle, and treat them as the session's first prompt.

## 2. During the session
- The moment something is left unresolved, record it: `session-note.sh <agent> <type> "<text>" --waiting-on "..." --links "..."`. Don't wait for the end, since sessions get cut off.
- When you settle an item, record how: `session-note.sh <agent> resolve <id> --ticket <ID>` or `--acted "<PR / merge / file / draft>"`.

## 3. Session end
- Make one call listing every open thread and every closure:
  ```
  session-note.sh <agent> - <<'EOF'
  [gap] ... | waiting_on: ... | links: ...
  [resolve] <id> | ticket: <ID> | verdict: ...
  EOF
  ```
- The writer validates the whole note before replacing it and prints each item's id. If nothing is open, write nothing.

## 4. Recurring loop (for example twice each weekday)
1. **Harvest:** export any conversation records the loop can read into `inbox/` as v1 notes, then run `harvest.sh`. It prints counts only.
2. **Adversarial verdict:** for each first-prompt candidate, copy `verdict-template.md` to `verdicts/<id>.md`:
   - List the options, including doing nothing and splitting the work.
   - Make the case for and against each option.
   - Battle them: pair each option's best argument for against the strongest argument against. Evidence checked in this run beats an assumption.
   - **Waterfall:** run the sequential gates and stop at the first that fails: hard rules, current evidence, reversibility, write scope, what it unblocks.
   - **Fan:** check parallel lenses: security, cost, dogfooding, reversibility, who else is touched.
   - Decide, and set a status.
3. **Act or ticket:** if the verdict resolves the item and the action is inside your write scope, do it, or launch the run it names. Otherwise file a ticket (bug = ticket, good idea = ticket, impressive find = epic) or leave one specific `waiting_on`. Never resolve without a ticket id or an action record.
4. **Re-harvest** so the view reflects the verdicts.
5. **Report only changes:** new items, resolutions, fired triggers, new stale items and harvest errors. Say nothing if nothing changed.

## 5. Weekly
- The harvester regenerates `weekly/<YYYY-Www>.md` on every run. It lists what opened and what resolved (with close-check), the repeat offenders (reopened, raised in two or more notes, corroborated, or stale), the sources holding the most open items, and learnings to promote.
- At the last loop of the week, promote each learning:
  - a standing rule goes into the team's protocol file or an assistant profile;
  - a procedure becomes a skill.
  Then resolve the item with the rule or skill path as `acted:`.
- Repeat offenders that stay stuck for two weeks get escalated to their owner, as a draft message.

## Guardrails
- The harvester never writes to the tracker. Ticket writes happen in step 3, under the team's bot identity.
- Output never contains secret values: harvested text passes through redaction, and the validator rejects token-like strings.
- Messages to people are drafts only.
- Back up any ledger file before changing the harvester, and keep the backup beside the original.
- When a source fails to harvest, leave its items alone. Never mass-resolve them.
