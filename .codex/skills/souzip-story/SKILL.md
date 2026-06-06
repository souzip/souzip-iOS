---
name: souzip-story
description: Split an approved Souzip Goal into PR-sized Stories and choose active Story candidates. Use after Goal approval when Story candidates or active Story 1-2 selection needs to be planned.
---

# Souzip Story

Use this skill after a Goal is approved.

## Read First

- `docs/harness/workflow/operating-sequence.md`
- `docs/harness/templates/story/story-template.md`
- `docs/harness/jira/workflow.md`
- `.agents/agents/workflow/story-splitter.md`

## Workflow

1. Verify that the Goal is approved.
2. Split Stories by technical boundary first.
3. If a technical Story is too large, split it again by user value.
4. Recommend active Story 1-2:
   - first: a small end-to-end slice
   - second: the highest technical risk, if needed
5. Mark any Story that is too large for Jira or worktree and must be split.
6. After active Story confirmation, hand off Jira work to `souzip-jira-story`.

## Output

- Story candidate list
- Active Story recommendation
- Split reasoning
- Jira handoff readiness for `souzip-jira-story`
- Questions that block Story confirmation

## Boundaries

- Do not create Plans.
- Do not edit code.
- Do not create Jira issues. Use `souzip-jira-story` instead.
- Do not start worktree setup until the active Story is confirmed.
- Keep actual Story documents local under `docs/goals/`; they are not committed.
