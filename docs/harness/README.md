# Souzip AI Harness

이 폴더는 Codex가 Souzip 작업을 진행할 때 따르는 흐름과 기준을 담습니다.
구현보다 먼저 요구사항을 명확히 하고, Story 단위로 PR을 나누며, 검증과 기록 가능한 산출물을 남기는 것이 목적입니다.

## 핵심 문서

| 파일 | 용도 |
|------|------|
| [`workflow/operating-sequence.md`](workflow/operating-sequence.md) | 실제 작업 순서 |
| [`workflow/story-plan-session.md`](workflow/story-plan-session.md) | Goal → Story → Plan 흐름 |
| [`workflow/gates.md`](workflow/gates.md) | 구현·커밋·PR을 막는 조건 |
| [`skills.md`](skills.md) | 워크플로우 실행 스킬 |
| [`agents.md`](agents.md) | 서브에이전트 역할과 승인 기준 |
| [`verification.md`](verification.md) | 검증과 실패 처리 |
| [`templates/`](templates/README.md) | Goal, Story, Plan 문서 양식 |
| [`context/`](context/README.md) | Souzip iOS 구현 맥락 |

## 기본 원칙

- 구현보다 먼저 인터뷰로 목표와 이해관계를 명확히 합니다.
- 목표 문서를 바탕으로 Story를 나눕니다.
- Story 하나는 PR 하나입니다.
- Plan 하나는 한 세션에서 구현과 검증까지 끝낼 수 있어야 합니다.
- Story worktree는 항상 `develop` 기준으로 만듭니다.
- 실제 작업 순서는 `Goal → Story 후보 → active Story → worktree → Plan → 구현 → 검증 → PR`입니다.
- 반복 실행은 `souzip-goal`, `souzip-story`, `souzip-plan`, `souzip-verify`, `souzip-commit`, `souzip-pr` 스킬로 나눕니다.
- 검증 실패는 Plan 범위 안에서 고치고 다시 검증합니다.
- 큰 구조 변경은 AI가 혼자 진행하지 않고 사용자에게 묻습니다.
