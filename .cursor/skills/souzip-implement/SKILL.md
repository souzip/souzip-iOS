---
name: souzip-implement
description: >
  Souzip implement 모드. 승인된 plan.md만 기준으로 코드 구현. 트리거: 구현해, 구현 시작해.
  plan 없이 implement 요청 시 G1으로 plan 먼저 제안.
---

# Souzip — implement 모드

정본: `docs/harness/workflows/00-triggers.md` · implement 전 `docs/harness/scripts/preflight.sh` (G0)

## 게이트 (진입 전 확인)

- **G1**: `docs/plans/{feature}/plan.md` 존재 + 사용자가 「구현해」/「구현 시작해」라고 했을 것
- 없으면 implement 하지 말고 **souzip-plan** 제안

## 구현

1. plan의 Before/After만 source of truth
2. 완료 항목은 plan에서 체크
3. plan 밖 파일·범위 → 멈추고 plan 갱신 (G2)
4. 새 판단 필요 → 멈추고 사용자 확인

## 테스트 (ADR-008)

- plan에 테스트 항목 있으면 RED→GREEN 순서 권장
- 없으면 plan에 적힌 수동 검증 따름

## 이탈 (G5)

방향 틀리면 패치 누적 금지 → git revert → plan 재작성

## 다음

구현 후 **souzip-verify** 권장 (한 줄 안내)
