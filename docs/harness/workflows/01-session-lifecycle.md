# 세션 라이프사이클 (LHE C + A + D)

> 정본: [`00-triggers.md`](00-triggers.md) · 진입: [`AGENTS.md`](../../../AGENTS.md)

---

## 세션 시작 (코드 작성 전)

1. `pwd` — 저장소 루트인지 확인
2. [`progress.md`](../progress.md) — Current Verified State · Next action
3. 작업 기능이 있으면 `docs/plans/{feature}/plan.md` (+ `feature-tracker.json` 있으면)
4. `git log --oneline -5`
5. **implement 예정이면** `docs/harness/scripts/preflight.sh`  
   - 실패 → 기준선 복구 우선, 새 기능 중단 (G0)

## 작업 중

- **한 번에 하나** — `feature-tracker`의 `in_progress`는 1개
- 코드만 썼다고 완료 표시 금지 — **evidence** 필요
- plan에 없는 파일 → G2 (plan 갱신)

## 완료 정의 (DoD)

기능·마일스톤이 끝났다고 할 때 **모두** 충족:

1. `plan.md` **§완료 기준** 체크
2. 필요한 검증 **실행** (preflight, 빌드, plan 테스트)
3. **증거** — `progress` Session Record 또는 `feature-tracker.evidence`
4. 저장소가 preflight로 **재시작 가능**

## 세션 종료

1. [`progress.md`](../progress.md) — Session Record 추가, Current State 갱신
2. `feature-tracker.json` — status·evidence (있을 때)
3. blocker·Next action 명시
4. (사용자 「커밋해」 시만) ship — G4
5. `scratch/`는 버려도 됨 — 중요 내용은 progress·plan으로
6. (선택) 이번 세션 마찰·회고가 있으면 [`friction-log.md`](../friction-log.md) 한 행 — 개선은 하지 않음 ([`02-harness-improvement.md`](02-harness-improvement.md))

## clean-state (짧게)

- [ ] preflight 통과 또는 실패가 progress에 기록됨
- [ ] `in_progress` 기능이 없거나 의도적으로 남김
- [ ] 다음 세션이 progress만 읽고 이어갈 수 있음
