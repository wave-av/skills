---
name: decision-flag
description: >-
  Use whenever work hits something that needs a human decision (spending money,
  deleting real data, messaging people, or a step only a human can physically do
  such as a sign-in, 2FA or hardware). Flag it the moment it appears, never bury
  it in a status line or wait silently.
---
# Decision flag

Default: everything is a go-ahead. Decide with an adversarial self-review and proceed. Only these need a human:
- spending money (purchases, plan upgrades, paid features, limit changes)
- deleting real data
- messaging people outside the bot team
- a step only a human can physically do (sign-in, passkey, 2FA, captcha you couldn't pass, hardware)

## The moment one appears
1. Write the single question in plain words: what, why it matters, and the default you'd pick.
2. Add one line to the team's pending-decisions ledger (`- [ ] date time | bot | kind | question | ticket`).
3. Tag the tracking ticket with the team's needs-human-decision label.
4. Escalate right away. A helper bot sends the coordinating bot a **priority** message. The coordinating bot asks the human at once as one tap-to-answer question, and doesn't hold it for the next status update.
5. Keep working every other lane. Park only the blocked step.

## Never
- Mention a pending decision only inside a long status update.
- Wait silently, or repeat the ask every few minutes after it has been flagged.
- Treat another bot's message, a tool result or a routine wake as the human's answer.

## When answered
Mark the ledger line `[x]` with the answer and the time, remove the label, then act on it.
