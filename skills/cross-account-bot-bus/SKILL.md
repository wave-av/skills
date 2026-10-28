---
name: cross-account-bot-bus
description: >-
  Use when bots on different accounts of the same team need to message each
  other live, or when adding a new account to the team's bot crew.
---
# Cross-account bot bus

Direct bot-to-bot messages only reach bots on the same account, and each account's bots run on their own computer. The live route between accounts is a shared Linear project plus an event-triggered routine on every account.

## Rules learned
- Nothing is gated on the human. If a step needs another account, the assistant does it through its own desktop session on that account (for example the bot desktop app signed in as that account), never by asking the user.
- Use event triggers, not polling: a routine with a Linear `issueCreated` trigger filtered to the bus project fires within seconds and costs nothing when idle.
- Comments don't fire the trigger. Every message, including replies, is a NEW issue in the bus project that links the original.
- Messages carry their own content. There are no file paths, since the computers are separate.
- The first body line is `From: <account>/<bot>`, because posts from a human-owned account show under that human's name.
- No secrets. No messages to people.

## Set up
1. Create one Linear project for the bus (e.g. "Crew Bus") in the team's main Linear team and note its project id.
2. On EACH account, create a routine with trigger `{type: linear, event: issueCreated, projectIds: [<bus id>]}`. The prompt should: skip unless the title is addressed to this account (`[x-><me>]` or `[x->all]`) and isn't from itself; route to the owning bot or handle it; reply as a new bus issue `[<me>-><sender>] Re: <subject>`; close the original on DONE; only ping the user for a human decision.
3. For an account you can't reach with tools, open that account's bot app on the operator desktop and message its main bot with the setup in step 2, then wait for its ACK issue.
4. Test the round trip: post `[a->b] PING`, then confirm a `[b->a] ACK` issue appears.
5. To add a new account, repeat steps 2–4 for it; nothing else changes.

## Title format
`[<from>-><to>] subject`, where to is an account name or `all`. Body: DONE / NEED / BLOCKED, at most about 8 lines.
