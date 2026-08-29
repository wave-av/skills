---
name: wave-media
description: Upload, manage, and deliver video and audio through WAVE's media API. Use when the agent needs to ingest media, transcode between formats, extract clips, generate captions or transcriptions, or publish live streams. Every operation is one HTTP call, payable per-use with no account.
---

# WAVE Media

WAVE is video infrastructure for AI agents: one API for live and on-demand media.

## When to use this skill

- Ingest a video file or stream and get a playable asset back
- Transcode between formats (HLS, MP4, WebM, and more)
- Extract a clip by timestamp range
- Generate captions or a full transcription
- Publish or subscribe to a live stream (WebRTC, WHIP/WHEP)

## Authentication

Two paths, both documented at https://wave.online/auth.md:

- **API key** (bearer token) from https://console.wave.online
- **x402 pay-per-use** — call the endpoint, receive a 402 payment challenge, pay in USDC on Base, retry. No account needed.

## Core operations

```bash
# Ingest media
curl -X POST https://api.wave.online/v1/media \
  -H "Authorization: Bearer $WAVE_KEY" \
  -F "file=@video.mp4"

# Extract a clip
curl -X POST https://api.wave.online/v1/clips/detect \
  -H "Authorization: Bearer $WAVE_KEY" \
  -H "Content-Type: application/json" \
  -d '{"videoId": "vid_...", "start": 10, "end": 30}'

# Generate captions
curl -X POST https://api.wave.online/v1/captions \
  -H "Authorization: Bearer $WAVE_KEY" \
  -H "Content-Type: application/json" \
  -d {"videoId": "vid_..."}
```

## Machine-readable surfaces

- Full API reference: https://wave.online/openapi.json
- Agent discovery: https://wave.online/llms.txt
- Pricing: https://wave.online/pricing.md
- MCP server (all capabilities as tools): https://api.wave.online/mcp

## Error handling

Every error is a typed JSON object with a machine-readable `code`:
`AUTH_MISSING` (401), `SCOPE_REQUIRED` (403), `PAYMENT_REQUIRED` (402, with the x402 challenge), `RATE_LIMITED` (429, with Retry-After).
