# 협업 트리거·게이트 (정본)

> **정본 경로** — `docs/harness/workflows/00-triggers.md`  
> 하네스 제작 배경: [`docs/plans/agent-harness-rebuild/`](../../plans/agent-harness-rebuild/)  
> 세션 루틴: [`01-session-lifecycle.md`](01-session-lifecycle.md) · 하네스 개선: [`02-harness-improvement.md`](02-harness-improvement.md)

---

## 1. 파이프라인 (5모드)

```text
intake → plan → implement → verify → ship
         ↑__________|  「메모 반영」
```

| 모드 | 목적 | 산출물 | 코드 변경 |
|------|------|--------|-----------|
| **intake** | 범위·완료 정의·비목표 | `plan.md` 상단 또는 `scratch/` 메모 | ❌ |
| **plan** | 리서치 + Before/After + **완료 기준** | `docs/plans/{feature}/plan.md` | ❌ |
| **implement** | 승인된 plan만 구현 | 코드 + plan 체크 | ✅ |
| **verify** | plan·레이어·테스트·**증거** | 리뷰 노트 | △ (버그픽스만) |
| **ship** | 커밋·PR | git / `gh pr` | ❌ (G4) |

**기본 순서 (Full)**: intake(생략 가능) → plan → *(승인)* → **preflight** → implement → verify → ship(명시 시)

**Quick Flow (ADR-006)**: plan·verify·ship 생략 가능 — Factory·레이어·새 화면/API는 Full 필수.

---

## 2. 게이트

| ID | 이름 | 막는 것 | 풀리는 조건 |
|----|------|---------|-------------|
| **G1** | Plan | implement 코드·diff | `plan.md` + 승인·「구현해」 |
| **G2** | Plan 편집 | plan 밖 파일 | plan 갱신 후 |
| **G3** | Verify | “완료” 선언 | verify + **증거** 또는 “넘어가” |
| **G4** | Ship | commit·push·PR | ship + 명시 지시 |
| **G5** | 방향 이탈 | 패치 누적 | revert → plan 재작성 |
| **G0** | Baseline | 망가진 위에 구현 | `preflight.sh` 통과 |

---

## 3. 트리거 표 (한국어)

### 3.1 모드 진입

| 내가 말함 (예) | 모드 | AI가 함 |
|----------------|------|---------|
| “~ 만들고 싶어”, 큰 작업 | **intake** → **plan** | plan 작성, 대기 (G1) |
| “플랜만”, “리서치해줘” | **plan** | `plan.md`, 코드 ❌ |
| 「메모 반영해서 업데이트해」 | **plan** | `plan.md`만 |
| 「구현해」「구현 시작해」 | **implement** | preflight → plan만 구현 |
| 「리뷰해」「검증해」 | **verify** | 체크 + evidence |
| 「작업 시작」「worktree」「브랜치 만들어」 | **start** | Jira MCP · worktree · G4(commit/PR ❌) |
| 「커밋해」「~만 커밋해」 | **commit** | G4 · `souzip-commit` |
| 「PR 만들어줘」 | **PR** | G4 · `souzip-pr` · base `develop` |
| 「마찰 기록해」「왜 그렇게 했는지 기록해」 | **(기록)** | [`friction-log.md`](../friction-log.md) 한 행 · harness/스킬 **수정 ❌** |
| 「이거 토대로 개선하자」「하네스 개선하자」 | **plan** | [`harness-improvement/plan.md`](../../plans/harness-improvement/plan.md) 갱신 또는 당회 plan · 정본·코드 **대기 (G1)** |

### 3.2 모호할 때

- 크기 불명확 → Full vs Quick 1회 질문
- plan 없이 구현 → G1

---

## 4. Quick Flow — ADR-006

**바로 implement**: 오타, 한 줄 버그, “Quick으로 해”

**항상 Full**: 새 화면/VM/UseCase, Factory·Tuist, 레이어 경계

---

## 5. verify 체크리스트

- [ ] `plan.md` 범위 · **§완료 기준**
- [ ] Presentation → Data import 없음
- [ ] Domain · `!` · Combine 없음
- [ ] plan 테스트 있으면 실행
- [ ] **증거** → `progress.md` 또는 `feature-tracker.json`
- [ ] Factory 5단계 (필요 시)

---

## 6. LHE 산출물 (A~E)

| | 경로 |
|---|------|
| A progress | `docs/harness/progress.md` |
| B tracker | `docs/plans/{feature}/feature-tracker.json` |
| C DoD | `plan.md` §완료 기준 · `AGENTS.md` |
| D baseline | `docs/harness/scripts/preflight.sh` |
| scratch | `docs/harness/scratch/` (gitignore) |
| friction-log | [`docs/harness/friction-log.md`](../friction-log.md) |

---

## 7. 새 세션

1. `AGENTS.md` → [`progress.md`](../progress.md) → (기능 작업 시) `docs/plans/{feature}/`
2. `.cursor/rules/00-souzip-harness.mdc` + `souzip-*`
3. [`01-session-lifecycle.md`](01-session-lifecycle.md) · (하네스 개선 시) [`02-harness-improvement.md`](02-harness-improvement.md)

---

## 8. Cursor 스킬

| 모드 | 스킬 |
|------|------|
| 라우터 | `souzip-harness` |
| intake / plan | `souzip-intake` · `souzip-plan` |
| implement | `souzip-implement` |
| verify | `souzip-verify` |
| start | `souzip-start` |
| commit | `souzip-commit` |
| PR | `souzip-pr` |
| ship (라우터) | `souzip-ship` → 위 commit/PR |
