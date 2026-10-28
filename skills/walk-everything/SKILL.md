---
name: walk-everything
description: >-
  When the user asks to walk, test, QA, smoke-test or record a website, web app,
  dashboard or store end to end, to prove a UI or workflow change works, or to
  get a video, screenshots or a filmstrip of a flow, before you open a browser
  or write a test. Also when a site action has no tool and you want a WebMCP or
  MCP tool for it.
---
# Walk everything

Run a goal-driven, recorded walk of a web surface across its whole lifecycle. Each walk produces a video, numbered step screenshots, a captioned filmstrip, a Playwright trace, a report and a JSON step log. Where a site action has no tool, the walk generates a WebMCP or MCP tool stub with a test.

## When the work counts as done
A UI, surface or workflow change isn't finished until a walk of it is green, or its failures are ticketed. Link the report, filmstrip and video wherever the change is tracked (PR, ticket, session note).

## Run it
```
walk --url <base> --goal "<text>" [--auth <secret-name>] [--out dir]
```
* `--goal` is free text. "walk everything" or "full lifecycle" walks every stage. "pricing and sign-up" walks only those stages.
* `--auth` names a secret in the team's secret manager, never a value. Its value is JSON: `{login_url, username, password}` or a Playwright storageState. Values are never printed, and passwords are masked in screenshots.
* Useful flags:
  * `--scope domain` follows every host on the domain.
  * `--planner "<cmd>"` lets an LLM CLI choose between ambiguous routes: it reads JSON on stdin and prints an index.
  * `--fail-on fail|gap` is for CI.
  * `--headed` shows the browser.
* Install: `python3 -m venv .venv && .venv/bin/pip install -r requirements.txt && .venv/bin/python -m playwright install --with-deps chromium`. ffmpeg is needed for the mp4 and filmstrip files.

## What a walk does
1. **Discover:** open the base URL, collect links, buttons and the sitemap.
2. **Plan:** pick a route for each lifecycle stage: discover, store, signup, signin, onboarding, core, settings, billing, support, errors and signout. Stages that need a session are marked blocked when no `--auth` is given.
3. **Act:** click the real link (falling back to navigation), sign in from the secret, and open plan and product details.
4. **Assert:** HTTP status, a real 404, h1 and main, broken images, console errors.
5. **Record:** a screenshot and a JSON entry per step.

## Safety: stop, don't do
The walker stops and records a `blocked` step at pay, buy, checkout, subscribe, add-card, delete, deactivate, send, invite and publish. Use test or staging accounts only. Never submit payments, send messages to people or delete real data during a walk. A blocked step is a correct result, not a failure.

## Read the results (`runs/<date>-<target>/`)
* `filmstrip.png`: look at it first. One captioned tile per step, colour-coded pass, fail, warn or blocked.
* `walk.mp4` and `walk.webm`: the full session video. `filmstrip.mp4`: a 1 fps step slideshow.
* `report.html` and `report.md`: the step table, gaps and generated tools.
* `steps.json`: action, selector, URL, HTTP, result, ms, screenshot. `trace.zip`: open with `playwright show-trace`.
* `gaps.json`: missing routes, missing tools, HTTP errors, soft 404s, a11y and console errors.

## WebMCP and making new tools
* The current spec is `document.modelContext.registerTool(tool, {signal})`, `getTools()` and `executeTool()`. `navigator.modelContext` is the deprecated older surface. Check the WebML community group draft before relying on details.
* The walker injects a shim, so tools a page registers are listed in `webmcp.json` even in browsers without native support.
* Every form with no tool becomes `tools/<stage>-<form>.webmcp.js`, plus a fixture copy of the form and a `test_*.py` that registers the tool and executes it against the fixture. Run the test before you propose the stub. A missing route becomes an MCP stub (`*.mcp.py`) with a schema test.
* When you find a missing capability mid-task, run `walk toolgen --kind webmcp|mcp --name <verb-noun> --desc "<what it does>"`, then implement and test it.
* Mark tools that pay, delete or send with `consequentialHint: true`, and never auto-submit them.
* Each stub adds a line to `tickets.jsonl`. File those in the team's tracker, deduped by title.

## Run it everywhere
* **On demand:** the CLI above.
* **CI:** add a pipeline step that runs the walk against the preview URL on changes that touch UI, and against prod after deploy. Upload `runs/**` as artifacts and annotate the build with `report.md`. Use `--fail-on fail`.
* **Schedule:** walk every target daily, and file new gaps automatically.
* Keep a per-team `targets.md` (URL, surface, stages, auth secret name) next to this skill.

## Choosing an engine
The Playwright library is the engine of record: it has native video, screenshots and trace, and it is reproducible in CI. Browser MCP servers (Playwright MCP, Browser-use, remote browser services such as Kernel) are for exploring a new flow interactively, or for hosted login profiles and replays. Encode what you learn from them as targets or tools, so the recorded walk stays deterministic.
