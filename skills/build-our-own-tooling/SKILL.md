---
name: build-our-own-tooling
description: >-
  Use whenever a vendor's connector, MCP server, CLI, API wrapper or plugin
  can't do what the work needs (a missing endpoint, a field it doesn't expose, a
  capability gap). Instead of working around the gap or waiting on the vendor,
  build or extend a shared tool on the frameworks the team already has.
---
# Build our own tooling

Standing direction: build shared tools (CLIs, MCP servers, APIs, SDKs, skills, plugins) on the frameworks the team already has. A vendor's tooling gap is a signal to build, not a reason to stop, hand-wave, or route around it.

## When it applies
- A connector or MCP lacks a tool you need, but the vendor's own API (REST, GraphQL, webhooks) exposes it. Example: the Buildkite MCP can't show queue or agent health, but Buildkite's GraphQL API can.
- You're about to do the same manual API call, browser step, or scripted workaround a second time.
- A vendor CLI or SDK covers only part of a workflow.

## Steps
1. **Name the gap in one line.** What's missing, which vendor surface does expose it (API docs link), and what work it's blocking.
2. **Find the existing shared framework first.** Check the team's capabilities and standing-rules ledgers, shared tools, MCP servers, CLIs, skills and plugins for one to extend. Extend before creating; never start a parallel framework.
3. **Use what's already there to unblock now**, if it's safe and allowed (for example, a read-only call through an existing client). Don't let the build stall urgent work.
4. **File the build as a ticket** in the owning lane: the gap, the vendor API route, the framework to extend, the interface (CLI command, MCP tool, SDK method, skill), and acceptance tests.
5. **Build it the house way.** Credentials come only from the team's secret manager, never hard-coded or printed. Use narrow, short-lived tokens and read-only scopes by default. Ship with tests, through the normal PR and CI path.
6. **Make it discoverable.** Register the tool where every assistant can reach it (as an MCP tool, CLI or skill), note it in the capabilities ledger, and update any skill that used to describe the workaround.

## Don'ts
- Don't declare something impossible because a vendor connector lacks it.
- Don't scrape a signed-in session, copy cookies or tokens, or use undocumented internal endpoints when a documented API exists.
- Don't build a one-off script that only one assistant knows about. It belongs in the shared framework.
