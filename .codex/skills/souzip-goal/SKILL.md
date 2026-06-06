---
name: souzip-goal
description: Create or refine a Souzip Goal through interview before any Story, Jira, worktree, Plan, or code work. Use when the user wants to start a feature, clarify requirements, define success criteria, or produce/update a local Goal document under docs/goals.
---

# Souzip Goal

Use this skill to turn a feature idea into an approved Goal.

## Read First

- `docs/harness/workflow/operating-sequence.md`
- `docs/harness/templates/goal/goal-template.md`
- `docs/harness/templates/interview/interview-template.md`
- `.agents/agents/workflow/interviewer.md`

## Workflow

1. Ask interview questions in order, skipping anything already answered.
2. Ask only 1-3 questions at a time.
3. Draft or update the local Goal and interview documents under `docs/goals/{feature}/`.
4. Confirm the Goal checklist:
   - one-line goal
   - success criteria
   - out of scope
   - UI impact
   - API, data, domain impact
   - Story candidates
   - open questions or deferral reasons
5. Treat clear natural-language user agreement as Goal approval.

## Output

- Current Goal summary
- Open questions
- Goal checklist state
- Whether the Goal is approved

## Boundaries

- Do not create Jira Stories before Goal approval.
- Do not create a worktree before Goal approval.
- Do not create Plans before Goal approval.
- Do not edit code.
- Keep actual Goal and interview documents local under `docs/goals/`; they are not committed.
