---
name: souzip-pr
description: Prepare and create a Souzip PR only after the user explicitly says "PR". Use when performing PR readiness checks, develop changed-file overlap checks, Story completion verification, and PR body preparation.
---

# Souzip PR

Use this skill only when the user explicitly asks for a PR.

## Read First

- `.github/pull_request_template.md`
- `docs/harness/constitution.md`
- `docs/harness/workflow/operating-sequence.md`
- `docs/harness/workflow/gates.md`
- `docs/harness/templates/ship/pr-body.md`
- `docs/harness/verification.md`

## Workflow

1. Confirm the user explicitly said "PR" or an equivalent direct PR instruction.
2. Confirm all Story Plans are done.
3. Confirm Story verification has run.
4. Check `develop` changed-file overlap:
   ```bash
   git fetch origin develop
   git diff --name-only {base_commit}..origin/develop
   git diff --name-only {base_commit}..HEAD
   ```
5. If file lists overlap, stop and report the overlap.
6. Prepare the PR body with:
   - `📌 변경 요약`
   - `📌 변경 내용`
   - `📌 기타 참고 사항`
   - verification
   - develop overlap check
   - Jira link
7. Push only the intended Story branch when needed for PR creation.
8. Create the PR only after readiness checks pass.

## PR Title

- Jira key exists: `[SOU-xxx] {title}`
- Jira key missing: `[NO-ISSUE] {title}`

## PR Convention

Use the existing GitHub PR template:

```markdown
## 📌 변경 요약

## 📌 변경 내용

## 📌 기타 참고 사항
```

Write the Goal and Plan slice as a short summary only.
Actual Goal, Story, and Plan documents stay local under `docs/goals/`.

## Output

- Story completion status
- Verification status
- Develop overlap result
- PR body
- Push result when a branch push was needed
- PR result

## Boundaries

- Do not create a PR without explicit user instruction.
- Do not skip the develop overlap check.
- Do not hide skipped or failed verification.
- Do not push before the user explicitly asks for a PR.
- Do not push branches or create PRs for unrelated changes.
