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

## Never Commit (로컬 전용)

아래 파일은 worktree에 있어도 **stage·commit 금지**입니다. `git add -A` / `git add .` 사용하지 말고, 경로를 지정해 stage 하세요.

| 경로 | 이유 |
|------|------|
| `docs/lint-format-changelog.html` | lint/format 변경 설명용 로컬 HTML |
| `docs/goals/**` | Goal·Story·Plan 실행 문서 (로컬 보관) |
| `Config/*.xcconfig` | 시크릿 (`docs/harness/constitution.md`) |
| `tuist generate` 산출물 | `*.xcodeproj`, `*.xcworkspace`, `Derived/` |

제외 목록에 걸린 파일이 이미 staged 되어 있으면 커밋 전에 반드시 unstage 합니다.

```bash
git restore --staged <path>
```

## Workflow

1. Confirm the user explicitly said "커밋해" or an equivalent direct commit instruction.
2. Inspect changed files.
3. **Apply [Never Commit](#never-commit-로컬-전용)** — 제외 대상은 stage하지 않고, staged 되어 있으면 unstage.
4. Separate unrelated changes from the Story/Plan scope.
5. Check the latest verification result.
6. If verification is missing, report that before committing.
7. Draft a commit message using the existing Souzip convention.
8. Stage intended files only (`git add <path>…`). `git add -A` / `git add .` 금지.
9. Commit.

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
- Do not stage or commit [Never Commit](#never-commit-로컬-전용) paths — even if the user or a prior step created them.
- Do not include unrelated user changes.
- Do not push.
- Do not create a PR.
- Do not rewrite history.
