---
name: souzip-plan
description: Create a Souzip Plan for one implementation session inside a confirmed Story. Use when a Story is selected and Codex needs to define scope, tasks, verification commands, and stop conditions before the user says "구현해".
---

# Souzip Plan

Use this skill to create a Plan that can be implemented and verified in one session.

## Read First

- `docs/harness/workflow/operating-sequence.md`
- `docs/harness/templates/plan/plan-template.md`
- `docs/harness/verification.md`
- `.agents/agents/workflow/planner.md`

## Workflow

1. Confirm the Story is approved and has a `develop` base.
2. Define this Plan's exact scope.
3. Define what is out of scope.
4. List implementation tasks.
5. Add verification commands:
   - default: `docs/harness/scripts/verify.sh plan`
   - related tests with `VERIFY_TEST_TARGETS` or `VERIFY_TEST_SCHEME` when applicable
6. Add stop conditions for structural changes.
7. Wait for user approval and the explicit "구현해" instruction before code edits.

## Output

- Plan draft
- Verification command
- Related test target or skip reason
- Stop conditions
- Approval status

## Boundaries

- Do not edit code before the user says "구현해".
- Do not widen scope to finish implementation faster.
- Do not ignore missing verification.
- Keep actual Plan documents local under `docs/goals/`; they are not committed.
