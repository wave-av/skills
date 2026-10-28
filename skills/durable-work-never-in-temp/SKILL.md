---
name: durable-work-never-in-temp
description: >-
  Use whenever starting or supervising a coding/agent session, creating a
  worktree, clone, draft, evidence file, or any work that must survive a crash
  or reboot; also when reviewing scripts or tools that write to /tmp, $TMPDIR or
  os.tmpdir.
---
# Durable work, never in TEMP

TEMP (`/tmp`, `/private/tmp`, `$TMPDIR`, `os.tmpdir()`, `mkdtemp`) is wiped on reboot and by OS cleanup. One host crash can erase every session, worktree and draft kept there. TEMP is only for throwaway scratch that's deleted in the same run.

## Rules
1. **Pick a persistent home first.** Put sessions, worktrees, clones, drafts, evidence and logs under a persistent root (e.g. `~/.<org>/work/<session>/`, or inside the repo). Never under TEMP.
2. **Point tools away from TEMP.** Before launching an agent CLI (Claude Code, Muse, opencode, etc.), set its working dir and any scratchpad or worktree location to the persistent root. If a tool insists on TEMP, export `TMPDIR` to a persistent per-session dir for that process.
3. **Commit and push WIP early and often.** Use a WIP branch (or `git stash create` plus a ref) at least every ~15 minutes and at every milestone. Unpushed work on one disk counts as already at risk.
4. **Checkpoint progress.** Write a short checkpoint (goal, branch, HEAD, next step, transcript pointer) outside TEMP on every milestone, so a session can be resumed after a reboot.
5. **Isolate sessions.** Run each heavy session with memory/CPU caps (Node `--max-old-space-size`, ulimit, launchd/cgroups) under a supervisor that kills only the runaway one. One session must never be able to take down the host.
6. **Never auto-restart a human's sessions** after a crash. Build a resume list and let the owner choose.
7. **Guard in tooling and review.** Tools that take a store or work path must refuse TEMP paths (fail with a clear `temp-path` error). In review, flag any durable write into TEMP as a bug.

## Checklist before starting work
- [ ] Work dir is outside TEMP
- [ ] Tool scratch/worktree dirs redirected
- [ ] WIP branch exists and pushes
- [ ] Checkpoint file location chosen
- [ ] Memory cap set for heavy sessions

## After a crash
Inventory what was in TEMP from transcripts or logs (read-only), ticket each loss, recover what's still on disk, and add a guard so the same path can't be used again.
