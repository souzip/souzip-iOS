---
name: souzip-verify
description: Run or classify Souzip Plan and Story verification. Use after implementation, before closing a Plan, before closing a Story, or when verification failures need scope classification and retry guidance.
---

# Souzip Verify

Use this skill to verify completed work and classify failures.

## Read First

- `docs/harness/verification.md`
- `docs/harness/workflow/gates.md`
- `docs/harness/scripts/verify.sh`
- `.agents/agents/workflow/verifier.md`

## Workflow

1. Identify whether the target is `plan`, `story`, or `pr`.
2. Run the matching verification command when appropriate:
   - Plan: `docs/harness/scripts/verify.sh plan`
   - Story: `docs/harness/scripts/verify.sh story`
3. Include related tests with `VERIFY_TEST_TARGETS` or `VERIFY_TEST_SCHEME` when applicable.
4. Record passed checks, failed checks, skipped checks, and skip reasons.
5. Classify failures:
   - Plan scope: fix and rerun the same verification.
   - Structural scope: stop and ask the user.
   - Repeated failure: switch to root-cause investigation.

## Output

- Commands run
- Verification results
- Failure classification
- Fix/retry recommendation
- Remaining risk

## Boundaries

- Do not claim completion without freshly run verification results.
- Do not treat lint/build success as test success.
- Do not make Tuist, Factory, module boundary, or layer-rule changes without user confirmation.
