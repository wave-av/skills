---
name: lane-packet-spawn
description: >-
  Use when spawning or briefing any subagent, worker lane or parallel agent
  (feature, spike, harvest, review), and after a wave of lanes finishes, to
  audit where its time and tokens went and bank the fixes.
---
# Lane packet spawn: briefed spawn, receipted delivery, audit, bank

A lane that starts from a bare objective pays most of its cost re-learning context. Measured on real lanes: about 44% of tokens were pure recon. The parent reads once and hands every lane a packet; the audit makes each wave cheaper than the last.

## 1. Spawn with a packet, never a bare objective
The brief must contain:
- **Context:** exact paths, docs, neighbour code and pipeline definitions the lane needs, pasted or pointed at in one brief file. N lanes must not each re-read the same tree.
- **Exact verify commands** with expected counts (`<test command> → expect 142 pass`). Never just "run the tests".
- **Known-red baseline:** every check that is already red on the base branch, with its receipt. A lane that finds red matches it against this list before investigating.
- **Scope fence and budget:** what done looks like, what is out of scope, the call or time budget, and where to work (its own worktree and branch, never the shared checkout).
- **Standing rules the lane must follow:** no secrets in argv, logs, chat or tickets; CI on Buildkite only, never GitHub Actions; no bypassing branch protection; allowlist-first for any config or access change; outbound messages are drafts only; no messaging people.
- **CI-venue rule:** if the CI queue is red or starved for reasons outside the lane, the lane records "venue-blocked" with the build link and moves on. Proving the red is not the lane's fault is the parent's job.
- **Anything the lane cites but can't read:** paste its exact one-line semantics, or sequence the lanes.
- **Report-back shape** (step 2).

## 2. Deliver with receipts
The lane reports: diff stat, test counts re-run by the lane, ticket and PR links, CI build status with link, and anything that surprised it. No receipts means not done. The parent re-verifies one claim from each lane before quoting it.

## 3. Audit the trajectory
After each wave, replay the run log by event type rather than reading the prose:
1. Find the session or run log (decompress if needed).
2. Count events by type, and pull the timeline of steps and tool calls.
3. Compute the deltas: step durations, tokens per step, tool payload sizes, reasoning versus answer volume, calls per PR.
4. Name the single biggest waste in one sentence tied to a measured delta, and route it (packet template, model choice, tooling, known-red table).
Never use a naive grep for metrics; tool outputs quote other logs and inflate counts. Parse structured events.

## 4. Bank the fixes
Write the audit's top fixes into the lane brief template and the known-red table (kept in the working ledger, not in this skill). A fix discussed but not written down did not happen. Then spawn the next wave against the updated template.

## Known-red table (template, lives in the ledger)
| Check | Red since | Receipt (base ref + failing output) | Lanes must not |
|---|---|---|---|
Append rows; delete one only with a green receipt on the base branch.

## Anti-patterns
- "Investigate X" with no packet.
- A lane debugging venue-red as if it were its own red.
- Auditing without banking.
- Deleting a known-red row because "it might be fixed".
- Letting a lane grind a flaky external rail: pre-flight it, cap retries, and report persistent flake early with the failing ref.
- Spawning speculatively (lanes cancelled before their first step), or one lane per micro-check. Batch related checks into one lane.
