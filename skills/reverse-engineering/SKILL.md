---
name: reverse-engineering
description: >-
  Use before analyzing, decompiling, auditing, or documenting a binary, firmware
  image, mobile app, wasm bundle, or network protocol, whether your own build
  (supply-chain check) or a third-party target (security review or clean-room
  interop). Read it BEFORE installing any RE tool or pointing one at a file.
---
# Reverse engineering

RE here means static analysis, decompilation, firmware carving and protocol capture. It does **not** mean running untrusted code. Dynamic analysis (Frida, executing a sample) is a separate step that needs its own approval.

## Guardrails (read every time)
1. **Authorization gate.** Your own builds and open-source code you hold the licence for are fine to analyze. For anything third-party (vendor binary, firmware, competitor app), STOP until legal counsel and the owner have signed off, and that sign-off is recorded on the ticket.
2. **Sandbox only.** Analyze only inside a read-only container with no network (`--network=none`). Never analyze a file in a normal working directory where env vars or secrets are present.
3. **No execution by default.** Use static tools only. Running the target needs a separately approved profile plus the authorization gate.
4. **Secrets stay private.** Embedded keys or tokens you find go straight to whoever owns security. Never put them in a ticket, comment or report.
5. **Clean-room for interop.** Whoever writes the spec from observed behavior does not write the implementation, and no code is copied.

## Lab
- Rootless podman or a disposable microVM. No home-dir bind mount, no secret-manager env, no CI tokens.
- No network. Mount the input read-only, with one writable scratch dir for projects and the report.
- Any MCP server binds to 127.0.0.1 inside the container only.
- Record the tool versions, the input's sha256 and the exact script. Write the report to `<ledger>/re/<sha256>/report.md`.
- In CI, use only an isolated queue with no secrets.

## Tools (check version and licence at install)
| Need | Tool | Licence |
|---|---|---|
| Scriptable decompile | Ghidra headless (`analyzeHeadless`) | Apache-2.0 |
| Agent-driven decompile | pyghidra-mcp, ghidra-headless-mcp (read-only, loopback) | Apache-2.0 |
| Fast triage and scripting | radare2 + r2mcp, or rizin | LGPL-3.0 |
| Symbolic execution | angr | BSD-2 |
| Firmware carving | binwalk | MIT |
| Android | jadx + apktool | Apache-2.0 |
| Wasm | wasm2wat, wasm-decompile, wasm-tools | Apache-2.0 |
| Protocol | tshark + mitmproxy + Kaitai Struct | GPL-2.0 / MIT |
| Dynamic (gated) | Frida | Apache-2.0 |

Binary Ninja's free tier is non-commercial only, so don't use it for company work.

## Workflow
1. Classify the target as own build, open-source or third-party. Third-party goes through the authorization gate first.
2. Hash the input and record where it came from.
3. Launch the sandbox.
4. Start static: format, imports, strings, endpoints, embedded secrets.
5. For a supply-chain check, diff against the SBOM or the expected build output.
6. For interop, capture behavior, write a clean-room spec, then implement it separately.
7. Write a dated report, keeping any secret findings out of tickets.
