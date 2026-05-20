---
name: souzip-harness
description: >
  Souzip AI 협업 하네스 라우터. 5모드(intake/plan/implement/verify/ship)와 게이트 G1-G4.
  작업 요청·기능 개발·AI 협업 시 적용. 모드 불명확 시 triggers.md 기준으로 souzip-plan 등 선택.
---

# Souzip Harness (라우터)

1. 읽기: `docs/harness/progress.md` · `docs/harness/workflows/00-triggers.md` · `AGENTS.md`
2. 사용자 메시지로 모드 판별 → 해당 **`souzip-*` 스킬** 본문 실행
3. 게이트 위반 시 1줄 이유 + 필요한 트리거 안내

| 모드 | 스킬 |
|------|------|
| intake | souzip-intake |
| plan | souzip-plan |
| implement | souzip-implement |
| verify | souzip-verify |
| start | souzip-start |
| commit | souzip-commit |
| PR | souzip-pr |
| ship | souzip-ship (라우터) |

Quick Flow: `triggers.md` §4
