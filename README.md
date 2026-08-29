# WAVE Skills

Official agent skills for [WAVE](https://wave.online) — video infrastructure for AI agents. Every
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
