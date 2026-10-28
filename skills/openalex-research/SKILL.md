---
name: openalex-research
description: >-
  Use before any research-heavy, product, positioning, architecture or 'is there
  prior work on X' task, and whenever papers, citations, literature, prior art,
  OpenAlex, trends, or a brand's market/tech landscape come up. Check the shared
  research library first, pull what's missing from OpenAlex with the `oa` CLI or
  openalex MCP tools, and save every useful search back.
---
# OpenAlex research

OpenAlex covers 270M+ scholarly works, authors, institutions, topics and funders (CC0). The wrapper is the `oa` CLI plus the MCP server (`oa mcp`). Both write to one shared library. The paths below are the defaults on a machine where the CLI lives at `/workspace/bin/oa` and the library at `/workspace/research/library/`; if the CLI is installed elsewhere, use that location instead.

## The loop (always)
1. **Check what we already know** (free): `oa lib know "<topic>" [--brand X] [--area slug]` or MCP `lib_know`. Also read `/workspace/research/library/INDEX.md` and `digests/<area>.md`.
2. **Pull only what's missing**, saving as you pull:
   `oa research "<query>" --why "<decision this informs>" --brand <BRAND> --project <TICKET> --area <slug> [--year 2022-2026] [--semantic] [--note W123=why]` (MCP `lib_research`). Same query + params on the same UTC day is deduped.
3. **Go deeper** when a work matters (not saved): `oa get W123|doi:...` (free), `oa cites W123`, `oa refs W123`, `oa related W123`, `oa trend "<query>"`, `oa group works author.id --filter ...`, `oa autocomplete institutions "frau"`.
4. **Record the insight**, not just hits: `oa lib note --topic "Opportunity: ..." --text "... (W123, W456)" --ids W123 W456 --brand X --area Y --project TICKET`. Per-result why: `oa lib relevance <search_id> W123 "<why>"`.
5. **Regenerate digests** after a batch: `oa lib digest --area <slug>`, then `oa lib index`.
6. **Cite** OpenAlex IDs (W...) and DOIs in tickets, docs and positioning.

## Choosing a search
- Keyword (stemmed) is default and cheapest ($0.001).
- `--semantic`: meaning-based, max 50 results, 1 rps, works only. Good for problem descriptions.
- `--mode title_abstract`: precise; use for date-windowed monitoring.
- `--exact` for wildcards (`--exact "transcod*"`).
- `oa list works -f ...`: filters only, $0.0001 (e.g. `-f publication_year:>2023 -f topics.id:T123`).
- Useful filters: `cites:W...`, `cited_by:W...`, `related_to:W...`, `authorships.institutions.ror:...`, `from_publication_date:YYYY-MM-DD` (free; `from_updated_date` is paid, don't use), `is_oa:true`, `type:article`.
- Concepts are deprecated; use topics.

## Budget and safety (hard rules)
- Free tier: $1/day, resets at midnight UTC. Costs: get free; list $0.0001; search/semantic $0.001; rerank +$0.001; content PDF $0.01 (avoid).
- `oa budget` shows usage. The client stops below $0.02 remaining (exit 4). Never `--force` past the budget.
- Never buy credits, upgrade a plan, or use paid changefiles/daily snapshot.
- The API key comes only from the secrets manager (`OPENALEX_API_KEY`), read via the environment. It is sent only as the `Authorization: Bearer` header. Never print it, put it in argv/URLs, paste it in chat or tickets, or copy it elsewhere.
- Use `--dry-run` to see the URL (no key) and estimated cost before big runs.

## MCP registration (stdio)
```json
{"mcpServers": {"openalex": {"command": "/workspace/bin/oa", "args": ["mcp"], "env": {"OA_AGENT": "<your-bot-name>"}}}}
```
Tools: lib_know, lib_research, lib_note, lib_list, oa_search, oa_semantic_search, oa_get, oa_citations, oa_group_by, oa_autocomplete, oa_budget. Restrict with `OA_MCP_ALLOW=...` / `OA_MCP_DENY=...`.

## Exit codes
0 ok; 1 upstream/network/other; 2 usage, bad ID or not found; 3 access (key not activated or paid feature); 4 budget guard or exhausted. Errors are JSON on stderr with `code` and `hint`.

## Library layout
`lib.sqlite` (searches, works, findings, notes, FTS5), `log.jsonl` (append-only audit), `digests/<area>.md`, `INDEX.md`. Area/brand map: `/workspace/openalex/seed/areas.json`. Daily refresh script: `/workspace/openalex/routines/refresh.py`.
