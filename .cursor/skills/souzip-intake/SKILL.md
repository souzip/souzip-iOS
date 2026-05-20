---
name: souzip-intake
description: >
  Souzip intake 모드. 새 기능·큰 작업 전 범위·완료 정의·비목표 정제. 소크라테스식 질문 한 번에 하나.
  트리거: 만들고 싶어, 기능 추가, 요구사항 정리, 범위 잡아줘. plan과 합칠 수 있음.
---

# Souzip — intake 모드

정본: `docs/harness/workflows/00-triggers.md` · `docs/plans/agent-harness-rebuild/vision.md` §성공

## 필수

1. **코드 변경 금지**
2. **한 번에 질문 1개** — 답 받은 뒤 다음
3. 산출: 완료 정의(3줄 이내)·비목표·`docs/plans/{feature}/` 경로 합의

## 다음

- intake만 끝나면 **souzip-plan**으로 `plan.md` 작성
- 사용자가 한 턴에 끝내길 원하면 plan 상단에 intake 결과를 넣고 plan 모드로 이어감

## 기록

- 막힌 가설·메모 → `docs/harness/scratch/` (gitignore) · 중요한 것은 `progress.md`
