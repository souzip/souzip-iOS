# Souzip Skills

Souzip workflow를 반복 실행하기 위한 Codex project skills입니다.
스킬 본문은 `.codex/skills/` 아래에 둡니다.

## Skills

| skill | 쓰는 시점 | 하지 않을 것 |
|-------|-----------|--------------|
| `souzip-goal` | 기능 아이디어를 Goal로 만들 때 | Story, Jira, worktree, Plan, 코드로 넘어가지 않기 |
| `souzip-story` | 승인된 Goal을 Story 후보와 active Story로 나눌 때 | 모든 Jira Story를 한 번에 만들지 않기 |
| `souzip-jira-story` | active Story 확정 뒤 Jira Epic·Story 초안·생성·연결이 필요할 때 | 초안 승인·명시 지시 없이 Jira 생성하지 않기 |
| `souzip-plan` | 선택된 Story를 한 세션 Plan으로 나눌 때 | “구현해” 전 코드 수정하지 않기 |
| `souzip-verify` | Plan 또는 Story 검증과 실패 분류가 필요할 때 | 방금 실행한 검증 없이 완료라고 말하지 않기 |
| `souzip-commit` | 사용자가 “커밋해”라고 했을 때 | 기존 커밋 컨벤션을 벗어나지 않기 · `docs/lint-format-changelog.html` 등 [로컬 전용 파일](../../.codex/skills/souzip-commit/SKILL.md#never-commit-로컬-전용) stage·commit 금지 |
| `souzip-pr` | 사용자가 “PR”이라고 했을 때 | 기존 PR 템플릿과 develop 변경 파일 확인을 건너뛰지 않기 |

## 위치

```text
.codex/skills/
├── souzip-goal/
├── souzip-story/
├── souzip-jira-story/
├── souzip-plan/
├── souzip-verify/
├── souzip-commit/
└── souzip-pr/
```

## 기준

- 구현 스킬은 아직 만들지 않습니다.
- 구현은 승인된 Plan과 사용자의 “구현해” 지시 아래에서만 진행합니다.
- 커밋은 `docs/harness/constitution.md`의 `<type>: <한국어 설명>` 한 줄 형식을 따릅니다.
- PR은 `.github/pull_request_template.md` 형식을 따릅니다.
- 실제 Goal, Story, Plan 문서는 `docs/goals/` 아래에 로컬 보관하고 Git에 올리지 않습니다.
