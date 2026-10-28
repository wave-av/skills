---
name: edge-case-loop
description: >-
  Use when writing or changing any regex, matcher, allowlist, denylist,
  validator, schema, secret-scan pattern, classifier or gate, when aligning
  names or keys across files, or when handling transient failures, to find edge
  cases before they bite and then check what the fix itself breaks.
---
# Edge-case loop

A happy-path test never sees the failure modes. Run this loop for every change to something that matches, scores, classifies or gates input, and recurse on the fix.

## The loop
1. **Enumerate** the edge cases from the taxonomy below that could apply, whether or not you think they will.
2. **Test both sides.** For each, a positive case (must match / must pass) and a negative case (must not match / must fail). A matcher with only positive tests is half-tested.
3. **Resolve and recurse.** Fix it, add the regression test, then ask: what does this fix break? Broadening a matcher adds false positives; retries add latency; renaming a key breaks a consumer. Run step 1 again on the answer.
4. **Receipt.** Record each resolved case with its positive and negative test in the change's PR or the ledger.

Stop when step 3 yields nothing that matters twice in a row, or when the next case is a person or vendor gate (record it; don't guess past it).

## Taxonomy
1. **Regex completeness.** `.` doesn't cross newlines (use `[\s\S]` or a flag). Literal lists miss synonyms and spellings ("cannot" vs "can't"). Bare substrings over-match; use word boundaries or anchors.
2. **Negation.** A positive-word matcher passes on its negation ("is not X" contains "X"). Add a dedicated negation check before the positive match.
3. **Transient vs real failure.** Rate limits, timeouts and burst errors are not verdicts. Retry with backoff; only a persistent failure is a result. A retry can never turn an error into a pass.
4. **Name and schema alignment.** The same thing named differently in two places silently drops data. When you add or rename a value, search every place that must name it (hidden-aware: `rg --hidden --no-ignore`) and verify the keys line up.
5. **Boundaries.** Empty, null, max length, timeout, and just-over / just-under every cap.
6. **Family parity.** An option added to one tool in a family is a gap in its siblings until proven otherwise.
7. **False positive / false negative balance.** Every broadening gets a negative guard.
8. **Platform differences.** The same pattern can behave differently across grep/regex engines and shells (GNU vs BSD/macOS grep, bash vs zsh). A tool that errors on a pattern must fail closed (stop the run), never silently match nothing.

## Allowlist-first gates
For allowlists and secret or policy gates specifically:
- Default deny: anything not on the list is rejected, and the test suite includes an unlisted input that must fail.
- An empty or unreadable allowlist must fail closed, with a test proving it.
- A pattern error, missing file or parse failure must stop the gate, never pass it.
- Test inputs for secret scanners use obviously fake values; never paste a real credential into a test or fixture.
- Run the tests in the Buildkite pipeline as a required check, not only locally.

## Anti-patterns
- Hand-editing a recorded result to what you believe it should be. Retract and re-run clean.
- Only happy-path tests.
- Special-casing one input instead of fixing the matcher.
- Calling something unreachable or vendor-blocked without checking the configuration (wrong prefix, wrong endpoint, wrong key name) first.
