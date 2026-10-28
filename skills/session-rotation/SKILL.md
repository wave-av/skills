---
name: session-rotation
description: >-
  Use when running a long-lived session or watcher, when context is getting
  heavy or nearing compaction, before opening a large new phase on a warm
  context, when usage ran out faster than expected, or when deciding whether to
  continue, compact, or cold-start a successor session.
---
# Session rotation: spend tokens on answers, not memory

A session's cost is calls × context. Output is cheap; re-sending context is the bill. Compaction alone does not hold the floor: context regrows within about a thousand calls. So bank state, rotate on a schedule, and never trust a summary's numbers without re-measuring.

## Budgets
| Budget | Limit | Why |
|---|---|---|
| Session age | Rotate at about 24 hours | Multi-day sessions spent most of their input re-reading themselves |
| Parent calls | Rotate at about 1,500 | Calls × large average context dominates cost |
| Average input per call | Rotate early if it stays very high | Compaction regrowth |
| Speculative spawns | Zero | Lanes cancelled before their first step cost a full spin-up |
| Same-task re-spawns | More than 3: stop and diagnose | Retry storms pay full price and learn nothing |
| Child size | Review at about 30 calls; 100+ is a session in disguise | Promote it to its own lane with rotation, or stop it |
| Polling | Monitors, schedules or backoff, never a tight shell loop | Each poll re-sends the whole context |

## Measure before claiming
Any usage claim comes from a structured parse of the session log: parse each line as JSON, accept only the model-completion event type, and sum input, output and cached tokens by day. Never use a plain grep; tool outputs quote other logs. Attribute child sessions through the parent's spawn records, not by matching task names in child logs.

## Before a compaction: bank
1. **Read the band.** Use the context figure the harness gives you. If none is available, say the reading is unknown; never guess from another session's file (concurrent sessions and subagents make that wrong with full confidence).
2. **Bank durable state** to the working ledger: exact PR, SHA, build and ticket ids, next actions, and any receipts posted to the tracker. Keep the handoff seed current enough to cold-start a successor today.
3. **Write a START-HERE block in your final message before the compaction:**
   ```
   START-HERE — <focus>
   WHERE: <repo/branch, PRs, merged vs open>
   DONE: <2–4 things proven, each with a receipt>
   IN-FLIGHT: <the one thread, exact next action>
   NEXT STEP: <an action needing no permission and no waiting; or "nothing buildable — all open items wait on X">
   PARKED: <items blocked on a person or vendor only, each with what breaks without it>
   POINTERS: <ledger paths for big results; never re-paste big outputs>
   ```
   - NEXT STEP must be buildable. Sort by buildability, not importance. If you could start it yourself, it is not parked.
   - A filed ticket is not a task; filing it was the work.
   - Keep the block small. It is the part that works.
4. If the operator has to run the compaction, end with the single exact command to run.

## After a compaction
Re-read the ledger tail and the epic. Spot-check three banked facts against live state (one build, one PR, one file). Verify the base branch is current before acting. Then resume from NEXT STEP.

## Rotation: cold-start a successor, never resume
1. Bank state to the ledger and tracker (machine-readable ids and next actions).
2. Write a seed file: goal remainder (see mission-goal), last verified state, protocol, and the never-resume rule.
3. Start a fresh session from the seed. Its first banking pass records its own session id as canonical.
4. The old session becomes read-only evidence. Never run predecessor and successor together, and never resume the predecessor later, not after a quota reset and not when an old credential returns.
5. If a session fails because its account or credential changed, diagnose read-only (failure class from the log tail, whether the process is still alive), then hand off. Don't hand-edit session logs. Stop only the exact stuck process, and only after the user confirms it is closed.

## Checklist
- [ ] Usage measured by structured parse before any claim.
- [ ] Rotation scheduled (time or call count, whichever first).
- [ ] Spawns tracked by task name; no repeat more than 3 times.
- [ ] No tight poll loops.
- [ ] Heaviest child under about 30 calls, or reviewed with a written reason.
- [ ] Handoff seed fresh enough to cold-start today. No secret values in it.
