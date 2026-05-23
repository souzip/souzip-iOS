# harness-improvement — 하네스 지속 개선 루프

> **민감 정보 금지**: API 키·토큰·실계정·미공개 사업/수치·장문 내부 전략은 이 파일에 쓰지 않는다.

## intake 요약 (2026-05)

- **목표**: 하네스 초안을 쓰면서 **마찰·회고를 쌓고**, 사용자가 **「이거 토대로 개선하자」** 할 때만 정본을 고친다.
- **기록**: `docs/harness/friction-log.md` (git 추적)
- **개선 실행**: 이 plan + 승인 + 「구현해」 → workflow·README·트리거·(선택) 스킬
- **비목표**: 정기 harness 세션, 마찰마다 자동 수정, TDD 전면 도입(별도 작업), iOS 앱 코드 변경
- **제작 메타와 분리**: `docs/plans/agent-harness-rebuild/friction-log.md` 는 H3 역사용 — 일상 로그는 harness 쪽

---

## 목표

Souzip AI 하네스에 **이벤트 기반 개선 절차**를 추가한다. 평소는 `friction-log.md`에만 적고, 개선은 명시 트리거 + plan + G1 이후 반영한다.

---

## 비목표

- 매주·매 기능마다 harness 의무 점검
- friction 한 줄마다 AI가 `workflows` / 스킬을 자동 패치
- `agent-harness-rebuild/` 마일스톤 H3 완료 처리 (별도)
- 새 Cursor 스킬 파일 필수 (1차는 `00-triggers` 표 + workflow md만)

---

## 파악한 구조

| 있음 | 없음 |
|------|------|
| H3 dogfood·`friction-log` 언급 (`agent-harness-rebuild/milestones.md`) | `docs/harness/friction-log.md` |
| `01-session-lifecycle.md` 세션 종료 | harness 개선 전용 workflow |
| 5모드 `00-triggers.md` | 「마찰 기록」「개선하자」 트리거 행 |

---

## 변경 계획

### `docs/harness/friction-log.md` (신규)

- **이유**: intake 확정 — 일상 마찰·「왜 그렇게 했어」 회고 SSOT
- **Before**: 없음 (`agent-harness-rebuild/friction-log.md` 만 존재, 비어 있음)
- **After**: 아래 표 템플릿 + 상단 사용법 5줄

```markdown
# 하네스 마찰 로그 (friction-log)

> **운영 정본** — Souzip 기능 개발 중 하네스가 삐끗했거나, 「왜 그렇게 했어?」 회고할 때 한 줄씩 추가.  
> **개선 반영**은 사용자 「이거 토대로 개선하자」 + `docs/plans/harness-improvement/plan.md`(또는 당회 plan) + 「구현해」 후에만.  
> 제작 메타: `docs/plans/agent-harness-rebuild/friction-log.md` (H3, 참고만)

| 날짜 | 작업·세션 | 기대 | 실제 | 문서·스킬에 없던 것 | 조치 |
|------|-----------|------|------|---------------------|------|
```

---

### `docs/harness/workflows/02-harness-improvement.md` (신규)

- **이유**: 기록 vs 개선 게이트를 workflow로 고정
- **Before**: 없음
- **After**: [부록 A](#부록-a-02-harness-improvementmd-초안) 전문 (구현 시 파일 생성)

---

### `docs/harness/workflows/README.md`

- **이유**: workflow 목록에 02 추가
- **Before**:

```markdown
| [`01-session-lifecycle.md`](01-session-lifecycle.md) | 시작·DoD·종료 (LHE A/C/D) |
```

- **After**: 02 행 추가 — `하네스 마찰 기록·개선 루프 (이벤트 기반)`

---

### `docs/harness/workflows/00-triggers.md`

- **이유**: 트리거 표에 기록/개선 분리 (개선은 plan 모드, 기록은 문서만)
- **Before**: §3.1 모드 진입 표에 해당 행 없음
- **After**: §3.1에 추가

| 내가 말함 (예) | 모드 | AI가 함 |
|----------------|------|---------|
| 「마찰 기록해」「왜 그렇게 했는지 기록해」 | **(기록)** | `friction-log.md` 한 행 · harness/스킬 **수정 ❌** |
| 「이거 토대로 개선하자」「하네스 개선하자」 | **plan** | `harness-improvement/plan.md` 갱신 또는 당회 개선 plan · 코드·정본 **대기 (G1)** |

§6 LHE 표에 scratch 옆: `friction-log` → `docs/harness/friction-log.md`

---

### `docs/harness/workflows/01-session-lifecycle.md`

- **이유**: 세션 종료 시 “기록할 마찰 있었나” 한 줄
- **Before**: 세션 종료 5단계만
- **After**: 종료 체크에 선택 항목 추가

```markdown
6. (선택) 이번 세션 마찰·회고가 있으면 [`friction-log.md`](../friction-log.md) 한 행 — 개선은 하지 않음
```

---

### `docs/harness/README.md`

- **이유**: harness 인덱스에 friction·02 링크
- **Before**: `workflows/` 에 00·01만 암시
- **After**: 디렉터리 트리에 `friction-log.md`, `workflows/02-harness-improvement.md` · 짧은 표 1행

---

### `AGENTS.md` (선택·implement 시)

- **이유**: 진입점에서 friction 경로 한 줄
- **After**: Working Rules 또는 End of Session 근처 — 마찰은 `friction-log.md`, 개선은 명시 시 plan

---

### `.cursor/rules/00-souzip-harness.mdc` (선택·implement 시)

- **Before**: 5모드 표만
- **After**: 한 줄 — 「마찰 기록」/「이거 토대로 개선하자」 → `02-harness-improvement.md`

---

## 완료 기준

- [x] `docs/harness/friction-log.md` 존재·표 템플릿·상단 사용법
- [x] `docs/harness/workflows/02-harness-improvement.md` 가 부록 A와 동일
- [x] `00-triggers.md` §3.1 에 기록/개선 행 2개
- [x] `01-session-lifecycle.md` 선택 friction 한 줄
- [x] `workflows/README.md` · `harness/README.md` 링크
- [x] (증거) `progress.md` Session Record — “harness improvement loop 문서 반영”
- [x] (검증) iOS 코드 diff 없음 (`git diff` Projects/ 없음)

---

## implement 순서 (승인 후)

1. `friction-log.md` 생성  
2. `02-harness-improvement.md` 생성 (부록 A)  
3. `00-triggers` · `01-session-lifecycle` · README들  
4. (선택) `AGENTS.md` · `00-souzip-harness.mdc`  
5. verify — 문서만, 트리거 표 대조  

**preflight**: iOS 미변경이면 생략 가능 — plan에 “문서만” 명시.

---

## 참고

- intake: 채팅 2026-05 (B 이벤트 + 사용자 개선 게이트, 로그 경로 1번)
- `docs/plans/agent-harness-rebuild/milestones.md` H3 · `friction-log.md` (메타)
- TDD 전면 도입 — **별도 plan 보류**

---

## 부록 A — `02-harness-improvement.md` 초안

```markdown
# 하네스 지속 개선 (이벤트 기반)

> 정본: [`00-triggers.md`](00-triggers.md) · 세션: [`01-session-lifecycle.md`](01-session-lifecycle.md)  
> 로그: [`../friction-log.md`](../friction-log.md) · 개선 plan: [`../../plans/harness-improvement/plan.md`](../../plans/harness-improvement/plan.md)

---

## 1. 언제 쓰나

| 상황 | 할 일 | 하지 말 것 |
|------|--------|------------|
| AI가 게이트·스킬을 어김 | **기록** — friction-log 한 행 | workflow·스킬 즉시 수정 |
| 「왜 그렇게 했어?」 회고 | **기록** — 기대/실제/없던 문서 | 채팅만으로 끝내기 |
| 「이거 토대로 개선하자」 | **plan** — 개선 범위·Before/After | G1 없이 정본 수정 |

정기(매주) harness 점검은 **하지 않는다**.

---

## 2. 기록 절차

1. [`friction-log.md`](../friction-log.md) 표에 **한 행** 추가  
2. 열: 날짜 · 작업·세션 · 기대 · 실제 · 문서에 없던 것 · 조치(비워 둠)  
3. `progress.md` Session Record에 “friction N건” 한 줄 (선택)  
4. **조치** 열은 개선 implement 후에만 채움 (예: `00-triggers §3.1 행 추가`)

---

## 3. 개선 절차

1. 사용자 「이거 토대로 개선하자」 (또는 특정 friction 행 ID/날짜 지정)  
2. **plan** — `docs/plans/harness-improvement/plan.md` 갱신 또는 당회 mini-plan (변경 파일·Before/After)  
3. 사용자 승인 · 「구현해」  
4. **implement** — plan에 적힌 harness 파일만 수정 (iOS 코드 ❌)  
5. **verify** — 트리거 표·링크·friction 조치 열 기록  
6. (사용자 지시 시) **ship** — docs/harness 분리 커밋  

---

## 4. friction-log vs 기타

| | friction-log | scratch | agent-harness-rebuild/friction-log |
|--|--------------|---------|-----------------------------------|
| 용도 | 운영 마찰·회고 | 당일 임시 | H3 제작 메타 |
| git | ✅ | ❌ | ✅ (역사) |
| 개선 트리거 | 사용자 명시 시 plan | — | — |

---

## 5. 완료의 뜻 (이 루프 한 사이클)

- friction에 적힌 항목이 plan에 반영됨  
- harness 정본이 plan과 일치  
- friction **조치** 열에 “무엇을 고쳤는지” 한 줄  
```
