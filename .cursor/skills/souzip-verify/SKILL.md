---
name: souzip-verify
description: >
  Souzip verify 모드. plan 대비·iOS 레이어·테스트 점검. 리뷰 노트 위주, 코드 변경 최소.
  트리거: 리뷰해, 검증해, 코드 리뷰, 확인해줘.
---

# Souzip — verify 모드

정본: `docs/harness/workflows/00-triggers.md` §5 · ADR-008

## 필수

1. **“완료” 선언 전** 아래 체크 (G3)
2. 코드 변경은 plan 범위 버그픽스만

## 체크리스트

- [ ] 변경이 `plan.md` 범위 안
- [ ] Presentation → Data 직접 import 없음
- [ ] Domain 레이어 외부 의존 없음
- [ ] 강제 언래핑(`!`)·IUO 없음 (전역)
- [ ] Combine 없음 — RxSwift만 (전역)
- [ ] plan에 테스트 있으면 **실행** (실패 시 완료 선언 금지)
- [ ] Factory·새 피처 시 5단계 점검 (`CLAUDE.md` / layer constitution)
- [ ] **증거** — `docs/harness/progress.md` 또는 `feature-tracker.json` (G3)

## 산출

- 심각도별 이슈 목록 (Critical은 implement 재개 전 해결)
- **「PR 만들어줘」** → `souzip-pr`가 이 체크를 **먼저** 수행 (Go 전 `gh pr` 금지)
- 검증만 요청 시 PR 안내 가능 (강제 X)
