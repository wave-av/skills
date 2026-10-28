---
name: usage-efficient-crew
description: >-
  Use whenever a bot in a multi-bot crew is about to start background work, wake
  another bot, or post to a group, and whenever an account's usage is burning
  faster than its daily pace.
---
# Usage-efficient crew work

Lessons from a night when one seat burned 2-6%/h against a 0.6%/h pace. On that seat every bot turn, routine run and subagent bills the same account, so the cost is in turns and context, not in the task itself.

## What actually burns usage (in order)
1. **Fan-out from one coordinator.** Its own long-context turns plus many background executors and browser (computerUse) runs. That was ~60% of the spike.
2. **Wake-driven watchers.** A bot that wakes for every merge, CI or background completion and replies each time. One merge-watcher was ~17%.
3. **Relay chains.** A result that hops through 3-4 bots, each summarizing to the user. Every hop is a full turn with full context.
4. **Room posts.** One group post wakes every member, so it costs N turns, not one.
5. **Wasted model calls.** Expensive-model calls that hit max_tokens while thinking and return no text (~384k tokens lost on 4 calls).

## Rules
- **Pace first.** Know the seat's daily budget per hour, and each bot's share of it. Before starting work, check the latest reading; if the seat is over pace, start nothing that isn't on the critical path.
- **One worker per lane.** At most one background executor per workstream. Reuse it instead of starting new ones. Browser runs only when no API or connector covers the job.
- **Direct, not room.** Message the one bot who must act. Post to the room only when two or more bots must act. When a broadcast would cost more than it saves, send it to the coordinator only.
- **No acks, no FYI wakes.** Use priority (wake) only when the recipient must act. Batch status into one DONE/NEED/BLOCKED message, at most about 8 lines, with details in a ledger file.
- **Last bot tells the user.** Only the bot that finishes a task reports to the user; intermediate hops stay silent.
- **Throttle watchers.** Watch loops poll no more often than hourly, and pause overnight unless something is actively blocking.
- **Heavy thinking on the cheapest billed surface.** Push long reasoning or code generation to API credits or CLIs run in shells, not to bot turns. Cap max_tokens and thinking budgets so calls can't burn out with no output; retry smaller rather than repeating the same call.
- **Routines must be quiet.** A routine that finds nothing new ends with no message. Short-gap readings (<30 min apart) don't trigger alerts.
- **Keep context small.** Point to files instead of pasting them; summarize long tool output in the ledger and reference the path.

## When a seat spikes
1. Read the seat's usage now (admin API or dashboard) and log it with a timestamp.
2. Attribute by counting the last hour's turns, tool calls and subagent runs per bot from transcripts. Label shares as estimates when the billing data can't split them.
3. Send the coordinator one priority message naming the top culprits with numbers and the specific jobs to stop.
4. Re-read hourly. Lift the throttle only after two consecutive readings under pace.
5. If the second account is also over its line, don't shift load onto it; hold the work instead.

## Telemetry to keep
- Hourly seat readings in a log file, plus raw snapshots and a rollup. Never in TEMP.
- Each source marked live or a gap, so nobody re-investigates dead endpoints (e.g. a per-request events API that returns 0 rows).
