---
name: wave-search
description: Semantic media search through WAVE — index video content and search it by meaning, getting timestamped moments back. Use when the agent needs to find specific moments in videos, build searchable video libraries, or ask questions about video content with citations to exact timestamps.
---

# WAVE Search

Semantic media search: index video content, search by meaning, get timestamped moments.

## When to use this skill

- Find specific moments in a video library by natural-language query
- Build a searchable index of video content
- Ask a question about a video and get an answer cited to exact timestamps

## Quick start

```bash
# Index a video's captions for search
curl -X POST https://api.wave.online/v1/search/index \
  -H "Authorization: Bearer $WAVE_KEY" \
  -H "Content-Type: application/json" \
  -d '{"videoId": "vid_...", "chunks": [...]}'

# Search by meaning
curl -X POST https://api.wave.online/v1/search \
  -H "Authorization: Bearer $WAVE_KEY" \
  -H "Content-Type: application/json" \
  -d '{"query": "the part where the demo fails", "indexId": "idx_..."}'

# Ask a question with cited timestamps
curl -X POST https://api.wave.online/v1/search/ask \
  -H "Authorization: Bearer $WAVE_KEY" \
  -H "Content-Type: application/json" \
  -d {"query": "what was said about pricing?", "videoId": "vid_..."}
```

## Authentication

API key from https://console.wave.online, or x402 pay-per-use (no account): https://wave.online/auth.md

## Machine-readable surfaces

- API reference: https://wave.online/openapi.json
- Agent discovery: https://wave.online/llms.txt
- Pricing: https://wave.online/pricing.md
- MCP server: https://api.wave.online/mcp
