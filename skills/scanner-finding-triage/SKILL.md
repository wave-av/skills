---
name: scanner-finding-triage
description: >-
  Use when a security scanner, code auditor, dependency checker or vendor trial
  reports findings, before you cite, count, fix, file, dismiss or send any of
  them anywhere, or use them to justify a purchase or a priority call.
---
# Scanner finding triage: a finding is a hypothesis until you read the source

A scanner matches a pattern. A vulnerability needs the pattern, plus a reachable path, plus no mitigation. The more severe and decision-relevant a finding looks, the more likely it gets repeated before anyone checks it. This skill puts a gate where findings escape.

## 0. The gate
No finding leaves the tool until someone has read the source it points at. "Leaves the tool" means any of: quoted in a message or draft, counted in a metric or report, filed as a ticket, fixed, dismissed, or used to argue for a purchase. Reading the finding is not reading the source.

## 1. One verdict per finding
| Verdict | Meaning | Receipt it needs |
|---|---|---|
| `DUPLICATE` | Another tool or an existing ticket already has it | The other tool's finding id or the ticket id |
| `TRUE` | Real and reachable | File, line, and why it is reachable |
| `FALSE-POSITIVE` | The pattern matched; the vulnerability is not there | The disproof, in the detail you would want for a bug report |
| `STALE-PATH` | The default branch no longer has the file | The failed lookup, run against the repo the finding names |
| `OUT-OF-SCOPE` | The path is excluded by a written scope rule | The rule, written before triage (step 5), never decided at the row |

- Severity notes ride on a verdict; they are not a sixth verdict.
- No row is left blank, "probably" or "assumed". An unclassified finding inside a total makes the total fiction.
- Before you record `STALE-PATH`, confirm you queried the repo and branch the finding names. A lookup in the wrong repo returns the same empty result as a real absence.

## 2. Read from the ref, not the working tree
```bash
git -C <repo> fetch -q origin
git -C <repo> show origin/<default-branch>:<path>
```
A local checkout can be on another branch, half-built or stale. If the `show` fails in the right repo, the verdict is `STALE-PATH`.

## 3. Look for the line that defuses it
In order:
1. Where does the matched value flow: a trust decision, or only a lookup key, log line or label?
2. Is there a verification or sanitising call nearby, and does it always run?
3. What happens on the failure path: does it fail closed or fall through?
4. Name a concrete attack and check whether it works. A finding is `TRUE` only after you tried and failed to defuse it.

## 4. Record two severities
Write down the severity as rated by the tool and as shipped, with the reachability argument for the second. A critical in a test harness, an archived snapshot or an operator-only local CLI is real but may be negligible as shipped. Never let the as-rated number drive a decision on its own.

## 5. Fix the population before counting
- Rule vendored, generated, harvested, fixture and scratch paths in or out, in writing, before any count.
- Prefer a policy the repo already enforces (an existing exclusion in its CI config or scanner config) over a fresh judgment.
- Watch sibling paths: excluding one harvested folder does not cover a neighbour that only looks similar.
- Before you accept a bulk exclusion or dismissal, list what it drops and read the high-severity and secret items in that list. A bulk exclusion you have not listed is an unexamined risk.

## 6. Numbers come from the API, not the dashboard
Dashboards group, cap, cache and round. Any number that feeds a decision comes from the tool's API or export and states which population it counts.

## 7. Before a finding goes into anything outbound
- [ ] Source read from the ref; the defusing line actively looked for.
- [ ] A concrete attack named and tested, and it survived.
- [ ] Severity as shipped stated, not only as rated.
- [ ] The claim would hold if the recipient read the file, because they can.
- Outbound text is a draft for the user to approve, never a send.
- If a wrong claim already went out, correcting it is the user's call. Never restate it.

## 8. Recording results
- Put verdicts and receipts in the tracker or the ledger, never secret values: if a finding is a leaked credential, record the file, line and credential type only, and hand rotation to the owner.
- A `TRUE` finding gets a ticket with the receipt. A `FALSE-POSITIVE` gets its disproof attached wherever the dismissal is recorded, so the next scan's triage can reuse it.
- If the fix belongs in CI, it goes in the Buildkite pipeline as a check, never a GitHub Actions workflow.

## What this does not say
Scanners are worth running. A tool's value is the findings that survive your verification, not the count it reports. Run the tool; believe it last.
