---
name: wave-inference
description: Run LLM chat completions through WAVE's inference funnel with measured routing and automatic failover across 13 providers. Use when the agent needs to generate text, analyze content, or call models like deepseek-v4 or claude-sonnet-5 through one OpenAI-compatible endpoint.
---

# WAVE Inference

One OpenAI-compatible endpoint at https://inference.wave.online fronting 13 providers with measured routing, automatic failover, and per-token metering.

## When to use this skill

- Generate text with any frontier model through a single API
- Automatic failover when a provider drops
- Per-token cost tracking to eight decimal places

## Quick start

```bash
curl -X POST https://inference.wave.online/v1/chat/completions \
  -H "Authorization: Bearer $WAVE_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model": "deepseek-v4", "messages": [{"role": "user", "content": "Hello"}]}'
```

The same surface also serves the gateway path:

```bash
curl -X POST https://api.wave.online/v1/dispatch/chat/completions \
  -H "Authorization: Bearer $WAVE_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model": "deepseek-v4", "messages": [{"role": "user", "content": "Hello"}]}'
```

## Models (the live catalog)

- deepseek-v4 — $0.50/M in, $1/M out
- claude-sonnet-5 — $4.40/M in, $22/M out

Full list: https://inference.wave.online/v1/models

## Payment

API key or x402 pay-per-call (USDC on Base; the 402 challenge carries the full terms). Streaming requires `stream_options.include_usage: true` so usage is metered.

## Machine-readable surfaces

- API reference: https://wave.online/openapi.json
- Agent discovery: https://wave.online/llms.txt
- Pricing: https://wave.online/pricing.md
- MCP server: https://api.wave.online/mcp
