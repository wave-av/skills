# WAVE Skills

Official agent skills for [WAVE](https://wave.online) — video infrastructure for AI agents. Every <!-- # guard:allow plain-English word, not a repo reference -->
capability is one HTTP call, payable per-use with no account.

## Install

```bash
npx skills add wave-av/skills
```

## The skills

| skill | what it does |
|---|---|
| **wave-media** | Ingest, transcode, clip, caption, and publish media — one API for live and on-demand video |
| **wave-inference** | LLM completions through the measured-routing funnel: 13 providers, automatic failover, per-token metering |
| **wave-search** | Semantic media search: index video content, search by meaning, get timestamped moments |

## Skill index

Every directory under `skills/` is one skill, and this table is the list an agent and CI both use. A standing rule is marked REQUIRED: follow it whenever it applies, not only when a task names the skill. The when-to-use cell is that skill's frontmatter description.

<!-- skill-index: begin -->
| skill | standing rule | when to use |
|---|---|---|
| `build-our-own-tooling` | REQUIRED | Use whenever a vendor's connector, MCP server, CLI, API wrapper or plugin can't do what the work needs (a missing endpoint, a field it doesn't expose, a capability gap). Instead of working around the gap or waiting on the vendor, build or extend a shared tool on the frameworks the team already has. |
| `ci-blocker-diagnosis` |  | Use when a CI build, agent, queue, PR or deploy looks blocked, missing or 'needs a rebuild', before declaring a rebuild, asking a human, or claiming a vulnerability is or isn't live. |
| `cross-account-bot-bus` | REQUIRED | Use when bots on different accounts of the same team need to message each other live, or when adding a new account to the team's bot crew. |
| `decision-flag` | REQUIRED | Use whenever work hits something that needs a human decision (spending money, deleting real data, messaging people, or a step only a human can physically do such as a sign-in, 2FA or hardware). Flag it the moment it appears, never bury it in a status line or wait silently. |
| `durable-work-never-in-temp` | REQUIRED | Use whenever starting or supervising a coding/agent session, creating a worktree, clone, draft, evidence file, or any work that must survive a crash or reboot; also when reviewing scripts or tools that write to /tmp, $TMPDIR or os.tmpdir. |
| `edge-case-loop` |  | Use when writing or changing any regex, matcher, allowlist, denylist, validator, schema, secret-scan pattern, classifier or gate, when aligning names or keys across files, or when handling transient failures, to find edge cases before they bite and then check what the fix itself breaks. |
| `fpc-vm-access` |  | Use when a task needs a shell or a read-only check on a CI guest VM (registry, router, or a CI slot). Read it before opening a session on the operator workstation. |
| `landing-page-design` |  | Use when building, editing, or reviewing a landing page, marketing site, page section, or product mockup, or when animating a static design into showcase motion (MP4/GIF). Covers intake, structure, conversion copy, SEO, a token-driven visual system, states, motion, and verification. |
| `lane-packet-spawn` |  | Use when spawning or briefing any subagent, worker lane or parallel agent (feature, spike, harvest, review), and after a wave of lanes finishes, to audit where its time and tokens went and bank the fixes. |
| `mission-goal` |  | Use when the user asks for a goal or mission statement, when an effort will span more than one session or several agents, when work keeps getting lost or re-derived after context compaction, or when an existing goal's scope changes or a milestone is met. |
| `open-items-ledger` |  | Use when work spans many sessions or several assistants and nothing left unresolved may be lost, at session start (read the first-prompt list), during a session (record open threads), at session end (write the note), and in any recurring triage loop or weekly review of open items. |
| `openalex-research` |  | Use before any research-heavy, product, positioning, architecture or 'is there prior work on X' task, and whenever papers, citations, literature, prior art, OpenAlex, trends, or a brand's market/tech landscape come up. Check the shared research library first, pull what's missing from OpenAlex with the `oa` CLI or openalex MCP tools, and save every useful search back. |
| `reverse-engineering` |  | Use before analyzing, decompiling, auditing, or documenting a binary, firmware image, mobile app, wasm bundle, or network protocol, whether your own build (supply-chain check) or a third-party target (security review or clean-room interop). Read it BEFORE installing any RE tool or pointing one at a file. |
| `scanner-finding-triage` |  | Use when a security scanner, code auditor, dependency checker or vendor trial reports findings, before you cite, count, fix, file, dismiss or send any of them anywhere, or use them to justify a purchase or a priority call. |
| `session-rotation` |  | Use when running a long-lived session or watcher, when context is getting heavy or nearing compaction, before opening a large new phase on a warm context, when usage ran out faster than expected, or when deciding whether to continue, compact, or cold-start a successor session. |
| `usage-efficient-crew` | REQUIRED | Use whenever a bot in a multi-bot crew is about to start background work, wake another bot, or post to a group, and whenever an account's usage is burning faster than its daily pace. |
| `walk-everything` |  | When the user asks to walk, test, QA, smoke-test or record a website, web app, dashboard or store end to end, to prove a UI or workflow change works, or to get a video, screenshots or a filmstrip of a flow, before you open a browser or write a test. Also when a site action has no tool and you want a WebMCP or MCP tool for it. |
| `wave-inference` |  | Run LLM chat completions through WAVE's inference funnel with measured routing and automatic failover across 13 providers. Use when the agent needs to generate text, analyze content, or call models like gpt-5.6-luna, deepseek-v4, or claude-sonnet-5 through one OpenAI-compatible endpoint. |
| `wave-media` |  | Upload, manage, and deliver video and audio through WAVE's media API. Use when the agent needs to ingest media, transcode between formats, extract clips, generate captions or transcriptions, or publish live streams. Every operation is one HTTP call, payable per-use with no account. |
| `wave-search` |  | Semantic media search through WAVE — index video content and search it by meaning, getting timestamped moments back. Use when the agent needs to find specific moments in videos, build searchable video libraries, or ask questions about video content with citations to exact timestamps. |
<!-- skill-index: end -->

## Authentication (both paths)

- **API key**: https://console.wave.online → the same key authenticates every WAVE product
- **x402 pay-per-use**: call the endpoint, receive a 402 payment challenge, pay in USDC on Base,
  retry. No account needed. https://wave.online/auth.md

## Machine-readable surfaces

- Agent discovery: https://wave.online/llms.txt
- API reference (OpenAPI): https://wave.online/openapi.json
- Pricing: https://wave.online/pricing.md
- MCP server (all capabilities as tools): https://api.wave.online/mcp
- MCP server (docs corpus): https://docs.wave.online/mcp
- MCP server (billing): https://api.wave.online/v1/monetize/mcp

## SDKs

- TypeScript + the `wave` CLI: `npm install @wave-av/sdk`
- Python: `pip install wave-sdk`
- Go: `go get github.com/wave-av/wave-go`
## Buildkite runbook

`guard-content-policy` refuses a build when the normalized repository
identities differ: it compares host/owner/name (lowercased, scheme and
`.git` suffix agnostic), so SSH-vs-HTTPS spellings of the same
repository proceed while any other mismatch \u2014 including malformed or
empty identities \u2014 refuses. Secrets-queue steps consume host
credentials, so refusal is fail-closed (exit 2).
Trusted re-run procedure for a fork PR: run the pipeline from the
trusted base ref (a base-branch build) — never by re-running the fork
build itself. A re-run of the fork build keeps fork metadata
(`BUILDKITE_PULL_REQUEST_REPO` still points at the fork), so the guard
still refuses it; only a build whose head is the trusted base proceeds.
The host withholds secret injection from any fork build, and a manual
approval gate is required before any trusted re-run. Never approve a
re-run that executes PR-head code with host credentials.
