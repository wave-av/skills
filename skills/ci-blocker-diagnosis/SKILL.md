---
name: ci-blocker-diagnosis
description: >-
  Use when a CI build, agent, queue, PR or deploy looks blocked, missing or
  'needs a rebuild', before declaring a rebuild, asking a human, or claiming a
  vulnerability is or isn't live.
---
# CI blocker diagnosis: verify before you rebuild

The rule: never conclude that something is missing, broken or needs a rebuild from a single snapshot. Prove it from history and logs first.

## 1. "Agent or VM is missing"
1. Check whether the agent is **ephemeral**: look at the agent's connect/disconnect history in the CI API (Buildkite: recent builds' jobs list `agent.hostname` and timestamps), not only the currently connected list. A per-job guest that is absent between jobs is normal.
2. Check the host's watcher or launcher config (which VMs it creates per queue) before concluding that a VM is gone.
3. Only call it a rebuild need if no job on that queue has been picked up in the window where jobs were queued.

## 2. "Build is queued or red"
1. Open the actual build for the PR's head commit. Is it queued, running or failed? Read the failed jobs' logs.
2. When jobs fail on missing secrets, check the secrets allowlist rules: does the PR edit CI config (e.g. `.buildkite/`)? Are the secrets main-only? If so, split the PR: code fixes in one PR, CI config changes in another, verified on main after merge.
3. Compare the **installed** allowlist or config on the runner host with git main; stale installs are common.

## 3. "Repo has CI"
1. Confirm that a pipeline exists for the repo (Buildkite: pipeline lookup by repo). With no pipeline, "merge when green" can never happen: create the pipeline (no GitHub Actions) with lint, tests, a pin/advisory gate and a smoke test.

## 4. "Is the vulnerability live?"
1. Identify what is actually running in prod (deploy platform API: image digest, version, release date), not what the repo builds.
2. Read the advisory's exact affected version ranges from the source (GHSA or vendor). Never assume that only the latest versions are affected.
3. If prod is affected and a pinned fix exists: record the current digest as the rollback, deploy, smoke-test (health, an authed call, an unauthed 401), and roll back on failure.

## 5. "One environment"
A scanner's grouped resource (e.g. a "Prd" cloud account) may cover several projects. Enumerate them before you change settings.

## 6. Codify
Every finding above becomes a script, test or CI check plus a process-registry entry, not just a note. Ticket whatever isn't done yet.

## Learned 2026-10-24 (sweep)
- A build that sits in "scheduled" usually means queue capacity, not a failure. The isolated queue this repo uses (`fpc-isolated`) has only 2 agents, and long workstation builds can hold both. Check agents per queue (busy or idle) and the org-wide scheduled count before you rebuild anything; rebuilding only adds to the queue. Another isolated queue may sit idle while this one is full.
- Use the Buildkite MCP (list_builds, list_jobs) when the REST API returns 429. The 50 requests/min limit is per user, shared across agents.
- Aikido cloud findings (Supabase buckets, SSL) have no API to trigger a rescan. Verify the fix at the source (storage.buckets.public, Management API ssl-enforcement), then wait for the scheduled cloud scan or press Rescan in the UI.
- Some repositories lock a toolchain file so only a person at a terminal may bump the pin. Agents are blocked: report the exact new value and do not hand-edit the lock.
