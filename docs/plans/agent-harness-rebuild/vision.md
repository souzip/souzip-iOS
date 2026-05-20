# AI 하네스 — 비전

> **H0·H1·H2 확정** (2026-05-19)  
> 협업 정본: [`docs/harness/workflows/00-triggers.md`](../../harness/workflows/00-triggers.md) · 구조: [`docs/harness/README.md`](../../harness/README.md)

## 한 줄 정의

**Souzip에서 AI와 기능을 만들 때, 단계·게이트·문서 위치가 고정되어 내가 설계·승인 주도권을 잃지 않게 하는 협업 규약.** (ADR-001)

---

## §문제 — 반복된 고통

### 고통 1 — plan 검토 부담

| | |
|---|---|
| **상황** | wishlist M4처럼 `plan.md`가 길 때, 구현 전에 변경 범위를 검토해야 함 |
| **기대** | Before/After 위주로 빠르게 “승인 / 반려 / 메모”만 결정 |
| **실제** | 문서 전체를 읽느라 시간이 길고 스트레스가 쌓임 |
| **왜** | 형식은 있지만 **분량·스캔 구조**가 검토자 눈에 맞지 않음 (형식 유지는 ADR-010, 가독성은 H3에서 별도 실험) |

### 고통 2 — 스킬·규칙이 안 붙음

| | |
|---|---|
| **상황** | 「PR 만들어줘」「커밋해줘」, 또는 구현 전 플랜이 필요한 작업을 시킴 |
| **기대** | plan-before-code·create-pr 등 **정해진 절차**대로 동작 |
| **실제** | 가끔 플랜 없이 코드를 쓰거나, PR/커밋 절차를 건너뜀 |
| **왜** | 스킬/규칙이 **항상 로드되지 않거나**, “지금 어느 단계인지” 트리거가 불명확함 |

### 고통 3 — 워크플로 들쭉날쭉

| | |
|---|---|
| **상황** | 날마다·세션마다 AI에게 시키는 방식이 다름 |
| **기대** | 기능 크기에 맞게 **항상 같은 단계 순서**(5모드 또는 Quick Flow 예외) |
| **실제** | 어떤 날은 플랜 없이 구현, 어떤 날은 문서만 과함 |
| **왜** | 규약이 **레포 안 한곳**에 고정돼 있지 않아 나도 AI도 기준이 흔들림 |

---

## §성공 — 관찰 가능한 기준 (H0 확정)

| # | 성공 기준 (Yes/No로 판별) | 맞는 고통 |
|---|---------------------------|-----------|
| 1 | 기능 단위 작업마다 **지금 단계가 5모드 중 무엇인지** 말할 수 있고, AI도 그 단계 문서만 따른다 | 고통 3 |
| 2 | 인사이트·트러블슈팅·막힌 점을 **`decisions.md` / `plan.md` / `docs/harness/progress.md`** (임시는 `scratch/`)에 남긴다 (채팅만 X) | 문서화 |
| 3 | **Quick Flow 예외가 아닌 한**, 「구현해」·코드 diff·PR 전에 `docs/plans/{feature}/plan.md`가 있고, 내가 승인 또는 「메모 반영」을 한 번 이상 했다 | 고통 1·2 |
| 4 | 「PR 만들어줘」「커밋해줘」는 **ship** 단계에서만 처리하고, **커밋·push는 내가 명시할 때만** 한다 | 고통 2 |

**H3 목표 (고통 1, plan 가독성)**: plan 검토 시 **「변경 계획」+ Before/After**만으로 1회 안에 승인/반려/메모 — 템플릿은 H3에서 실험 (ADR-010).

---

## §비목표 — 하지 않을 것

- BMAD / Superpowers / OMX / gstack **플러그인·CLI 설치에 의존**하지 않음 — 패턴만 차용 (ADR-005)
- 에이전트가 내 승인 없이 **커밋·PR** (명시 지시 시만 ship)
- Superpowers식 **전 코드 TDD 강제** — verify·plan 기반 완화 적용 (ADR-008)

---

## §사용 맥락 (H0)


| 질문             | 답                            |
| -------------- | ---------------------------- |
| 주 사용자          | 1인 / 팀(미래)                   |
| 주 도구 (2026-05) | Cursor                       |
| 다른 도구도 쓸 가능성   | Codex, Claude (나중에 이전가능성 존재) |
| 하루 평균 AI 세션    | 대략 _회, _분                    |


---

## §협업 계약 (H1 확정)

상세 트리거·게이트: **[`docs/harness/workflows/00-triggers.md`](../../harness/workflows/00-triggers.md)** (ADR-002, ADR-013)

### 주도권 (ADR-011)

| 영역 | 최종 결정자 | AI 역할 |
|------|-------------|---------|
| 제품·범위·비목표 | 나 | intake에서 질문·옵션 제시 |
| 아키텍처·플랜 | 나 | plan 작성, 승인 전 코드 금지 (G1) |
| 구현·리팩터 | 나 | plan 범위 내 구현, 이탈 시 멈춤 (G2) |
| 완료·품질 | 나 | verify 제안, “완료” 선언은 G3 후 |
| 커밋·PR·push | 나 | ship + **명시 지시** 때만 (G4) |

### 파이프라인 (ADR-007)

`intake` → `plan` → `implement` → `verify` → `ship`

### 게이트 요약

| ID | 한 줄 |
|----|--------|
| G1 | 「구현해」+ `plan.md` 없으면 코드 ❌ |
| G2 | plan 밖 변경 → plan 갱신 후 진행 |
| G3 | verify 전 “다 했다” ❌ (테스트 ADR-008) |
| G4 | 「커밋/PR」명시 없으면 git ❌ |
| G5 | 방향 틀리면 revert → plan 재작성 |

### 트리거 요약

| 내가 말함 | 모드 |
|-----------|------|
| 큰 기능 요청 / 플랜 요청 | plan (+ intake) |
| 메모 반영해서 업데이트해 | plan |
| 구현해 / 구현 시작해 | implement |
| 리뷰해 / 검증해 | verify |
| 커밋해 / PR 만들어줘 | ship |

### 예외 (Quick Flow, ADR-006)

오타·한 줄 버그·단일 파일 명확 수정 → plan·「구현해」 생략 가능.  
Factory·레이어·새 화면·PRD 기능 단위 → **Full** 필수. → [`triggers.md` §4](./triggers.md)

### plan-before-code (ADR-002)

**흡수** — `souzip-plan` / `souzip-implement` + `harness/workflows/00-triggers.md` §3.3.

### create-pr (ADR-002)

**ship** — `souzip-ship` + `00-triggers.md` §3.4.

### Cursor · harness (ADR-012, ADR-003)

`.cursor/skills/souzip-*` + `harness/` 4층 · `AGENTS.md` 진입.

---

## 참고

- 기능 개발 문서 층: PRD → milestones → plan (`references.md` §1)
- intake를 plan과 **한 턴에 합칠지** 분리할지 → H3 dogfood 후 조정

