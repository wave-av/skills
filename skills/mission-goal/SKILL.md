---
name: mission-goal
description: >-
  Use when the user asks for a goal or mission statement, when an effort will
  span more than one session or several agents, when work keeps getting lost or
  re-derived after context compaction, or when an existing goal's scope changes
  or a milestone is met.
---
# Mission goal: one paragraph that keeps long work alive

Compaction keeps the gist and drops the ticket numbers, thresholds, settled decisions and lessons. A mission goal is one dense paragraph of at most 4,000 characters that a cold session holding nothing else can resume from, and that says when the work is finished. It always ends with a pause clause.

Not for a single PR, a one-session task or a status report.

## Anatomy, in this order (prose, one block)
1. **Outcome sentence.** The end state in one sentence, the tracking epic or ticket, ending with "each shown by receipts quoted in the record".
2. **Numbered workstreams (1)…(n).** Each is a checkable DONE state followed by its receipts (a)(b)(c): ticket and PR numbers, dates, thresholds, file names, run or build ids. If a workstream has two valid end states, name both and what each needs.
3. **Measurable targets.** Every target has a threshold, a date and a baseline where one exists. If there is no baseline yet, measuring it is the first receipt.
4. **Debt and reporting.** Known leftovers with their tracking ticket; where status gets posted, how often, and what closes the epic.
5. **Rules.** Standing constraints and hard-won lessons as flat imperatives. Every decision the user already made becomes a rule, never a gate. Typical set:
   - spend ceiling; no billing or plan changes;
   - no secret values anywhere (chat, tickets, PRs, logs, files, argv), only names and where they live;
   - CI on Buildkite only, never GitHub Actions; no bypassing branch protection;
   - allowlist-first for any access, scope or config;
   - outbound messages to people are drafts for the user to send;
   - one agent per worktree; every agent claim verified before it is quoted.
6. **User gates.** Open with "ask the user one plain-language question at a time with tap-to-answer options, recommendation first, then wait; never route around". List only what the user genuinely still has to decide (merges, credential mints, production deploys, spend, deleting real data, scope cuts).
7. **Impossible only if …** The narrow conditions under which the goal can't be met, so a session doesn't call it blocked because it is hard.
8. **Pause clause (last sentence, required).** "PAUSE IS ALWAYS ALLOWED: when what remains waits on a running agent, a date or a user gate, end the turn with the resume point stated (what fires next and when); a pause never fails this goal." Count it inside the 4,000.

## Procedure
1. **Gather live facts first:** epic and ticket ids, open PRs and their order, current values for each target, dates from their source, and every decision the user already made. Fan big gathering out to subagents and verify what comes back.
2. **Write** to `goal-<slug>.txt` in the working ledger folder (slug is kebab-case). One paragraph, plain text.
3. **Measure:** `wc -c goal-<slug>.txt`. Hard cap 4,000, aim for 3,500–3,950. Over the cap, cut words, never facts.
4. **Ground every claim.** Every id, date and threshold comes from something read in step 1. Unknown facts say how they will be established.
5. **Self-review** against the checklist, then give the user a one-line summary and the file path. Don't paste the paragraph into chat as a wall of text unless they ask for it.
6. **Keep it current.** When a decision changes a workstream, rewrite the same file in the same turn and re-measure.

## Optional milestone file
When the remaining work is mostly date-gated or user-gated, write `goal-<slug>-milestone.txt` (usually 1,000–1,800 characters):
- It names the mission file and the epic, and one end state you can finish now without waiting.
- It keeps the receipts requirement.
- It states user-gated steps as outside the milestone ("the user running X is their gate; the milestone is met when X is ready").
- It carries only the rules this step needs, and ends with the pause clause.
- When it is met, roll forward to M<n+1> from the mission file.

## Checklist
- [ ] Outcome sentence names the epic and requires quoted receipts.
- [ ] Every workstream is checkable and lists its receipts.
- [ ] Every target has a threshold and date (and baseline where one exists).
- [ ] Every id read live this session; no secret values.
- [ ] Settled decisions are rules; gates list only open decisions and use the one-question rule.
- [ ] Has "Impossible only if …" and ends with the pause clause.
- [ ] `wc -c` ≤ 4,000.

## Anti-patterns
- A goal that restates the plan instead of the done state and its proof.
- Gates for questions already answered.
- Vague receipts ("tests pass" instead of the count and where it ran).
- Letting it drift after a scope change.
- Idling under a goal with no pause clause, or answering a stop hook with "still waiting" over and over. Say it once, switch to a milestone, and keep building what you can.
