---
name: souzip-commit
description: Prepare and create a Souzip commit only after the user explicitly says "커밋해". Use when checking changed files, verification status, commit scope, and commit message for a Story or Plan.
---

# Souzip Commit

Use this skill only when the user explicitly asks to commit.

## Read First

- `docs/harness/constitution.md`
- `docs/harness/workflow/gates.md`
- `docs/harness/workflow/operating-sequence.md`
- `docs/harness/templates/plan/plan-template.md`

## Workflow

1. Confirm the user explicitly said "커밋해" or an equivalent direct commit instruction.
2. Inspect changed files.
3. Separate unrelated changes from the Story/Plan scope.
4. Check the latest verification result.
5. If verification is missing, report that before committing.
6. Draft a commit message using the existing Souzip convention.
7. Stage and commit only the intended files.

## Commit Convention

Use one line, Korean, no body, no `Co-Authored-By`.

```text
<type>: <한국어 설명>
```

Types:

- `feat`: 기능
- `fix`: 버그
- `refactor`: 구조
- `style`: 포맷
- `docs`: 문서
- `test`: 테스트
- `chore`: 기타

## Output

- Files to commit
- Files excluded
- Verification status
- Commit message
- Commit result

## Boundaries

- Do not commit without explicit user instruction.
- Do not include unrelated user changes.
- Do not push.
- Do not create a PR.
- Do not rewrite history.
