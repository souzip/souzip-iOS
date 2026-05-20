---
name: souzip-plan
description: >
  Souzip plan 모드. 리서치와 docs/plans/{feature}/plan.md 작성(Before/After).
  플랜 승인 전 코드 변경 금지(G1). 트리거: 플랜, 리서치, plan 작성, 메모 반영해서 업데이트해,
  기능 추가/만들고 싶어(구현 요청이 아닐 때), plan-before-code.
---

# Souzip — plan 모드

정본: `docs/harness/workflows/00-triggers.md` §1·§2

## 필수

1. **코드 변경 금지** (G1) — 「구현해」 전까지
2. `docs/plans/{feature}/plan.md` 작성 또는 갱신 (`{feature}`는 구체적 이름)
3. 리서치+플랜을 한 번에 작성한 뒤 **사용자 승인 대기**

## plan.md 포맷

템플릿: `docs/harness/templates/plan-template.md` (민감 정보 상단 금지 3줄 포함)

- `# {feature} 리서치 및 구현 계획`
- `## 파악한 구조`
- `## 변경 계획` — 파일별 **변경 이유**, **Before**, **After** (발췌, 실제 코드)
- `## 완료 기준` — `docs/harness/templates/plan-dod-section.md`

장문 초안·민감 가설 → `docs/plans/{feature}/draft-*` 또는 `notes-*` (gitignore), `plan.md`에는 요약만.

## 「메모 반영해서 업데이트해」

- `plan.md`만 수정. 코드 금지.

## Quick Flow

오타·한 줄·단일 파일 명확 수정은 plan 생략 가능 — `triggers.md` §4. 애매하면 Full vs Quick 질문 1회.

## 산출

- 큰 기능: PRD·milestones 링크가 있으면 plan 상단에 완료 정의·미포함 명시
