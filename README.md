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
