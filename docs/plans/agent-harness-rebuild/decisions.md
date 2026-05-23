# AI 하네스 — Architecture Decision Records

형식: **상태** · **맥락** · **결정** · **대안** · **결과(나중에 기록)**

---

## ADR-000 — 공동 제작 방식

- **상태**: Accepted (2026-05-19)
- **맥락**: 외부 하네스(Superpowers 등)를 설치·사용하기보다, Souzip에 맞는 규약을 장기간 함께 설계하고 싶음.
- **결정**: 기능 개발의 M1–M5처럼 **H0–H6 마일스톤**으로 하네스 자체를 제품처럼 만든다. `plan.md`의 디렉터리 트리는 H2 전까지 가설이다.
- **대안**: Phase 1–4 일괄 구현(기각 — “만들어진 걸 쓰는” 모드에 가까움)
- **결과**: _(H6 후 회고)_

---

## ADR-001 — 하네스 이름·한 줄 정의

- **상태**: Accepted (2026-05-19, H0 확정)
- **맥락**: H0
- **결정**: 한 줄 — *「Souzip에서 AI와 기능을 만들 때, 단계·게이트·문서 위치가 고정되어 내가 설계·승인 주도권을 잃지 않게 하는 협업 규약」* (`vision.md`). 루트 폴더명 `harness/`는 H2(ADR-003)에서 확정.
- **대안**: `harness/`, `agent/`, `.agent/`, 한글 폴더명
- **결과**: —

---

## ADR-002 — plan-before-code·create-pr 흡수 (H1)

- **상태**: Accepted (2026-05-19)
- **맥락**: H1; 기존 `.claude/skills/`와 중복 제거 방향
- **결정**:
  - **plan-before-code** → harness **plan** + **implement** 모드로 흡수. 정본: [`docs/harness/workflows/00-triggers.md`](../../harness/workflows/00-triggers.md) §3. 산출물·Before/After 포맷·G5(revert) 유지.
  - **create-pr** → **ship** 모드 전용. 정본: [`docs/harness/workflows/00-triggers.md`](../../harness/workflows/00-triggers.md) §3. base `develop`, Co-Authored-By 금지 유지.
  - H6 전까지 `.claude/skills/*` 파일은 삭제하지 않되, **충돌 시 `00-triggers.md` 우선**.
- **대안**: 스킬만 유지 / 폐기 후 triggers만
- **결과**: H4 `harness/workflows/` 이관 시 본문 이동

---

## ADR-012 — Cursor 스킬 이중화 (H1+)

- **상태**: Accepted (2026-05-19)
- **맥락**: 트리거 말만으로는 스킬이 안 붙는 고통(vision §고통 2); 사용자 요청
- **결정**:
  - `.cursor/skills/souzip-{harness,intake,plan,implement,verify,ship}/` 추가
  - `.cursor/rules/00-souzip-harness.mdc` — `alwaysApply`, 모드·G1·G4 요약
  - 스킬 description에 **한국어 트리거** 포함 → 에이전트 자동 선택 유도
  - `disable-model-invocation` 미설정(기본) — 자동 호출 허용
  - 정본: [`docs/harness/workflows/00-triggers.md`](../../harness/workflows/00-triggers.md); 스킬·rule은 링크·요약만
- **대안**: 말(트리거 표)만 / Superpowers 플러그인 설치
- **결과**: H5에서 iOS glob rule 추가 예정

---

## ADR-011 — 협업 주도권·게이트 (H1)

- **상태**: Accepted (2026-05-19)
- **맥락**: H1; vision §성공 3·4
- **결정**: 5모드 + 게이트 G1~G5 + [`docs/harness/workflows/00-triggers.md`](../../harness/workflows/00-triggers.md) 트리거 표. 주도권은 제품·플랜·ship 전부 **사용자**. AI는 명시 트리거·게이트 없이 커밋·구현·완료 선언 금지.
- **대안**: 3모드만 / 게이트 없음
- **결과**: H5 `.cursor/rules`에 G1·G4 요약 반영 예정

---

## ADR-003 — 정보 4층·진입점 (H2)

- **상태**: Accepted (2026-05-19)
- **맥락**: H2
- **결정**:
  - 루트 **`AGENTS.md`** + **`docs/harness/`** (도구 중립)
  - 4층: `constitution.md` · `context/` · `workflows/` · artifact=`docs/plans/{feature}/`
  - 협업 정본: `docs/harness/workflows/00-triggers.md`
  - 세션 스크래치: `docs/harness/scratch/` (gitignore)
  - 로드 정책: [`docs/harness/README.md`](../../harness/README.md)
  - artifact `plan.md` Before/After 유지 (ADR-010)
- **대안**: `agent/`, `.agent/`, triggers만 docs/plans에 유지
- **결과**: H4 context/workflows 이관 — [`docs/harness/migration-map.md`](../../harness/migration-map.md)

---

## ADR-004 — 첫 workflow 실험 대상

- **상태**: Proposed
- **맥락**: H3
- **결정**: _(미정 — 후보: plan)_
- **대안**: intake, verify
- **결과**: —

---

## ADR-005 — 설계 전 레퍼런스 학습 (H0a)

- **상태**: Accepted (2026-05-19)
- **맥락**: BMAD, Superpowers, OMX, gstack, 소크라테스, PRD, ADR 등을 설치 없이 학습·문서화한 뒤 하네스에 선택 적용하고 싶음.
- **결정**: [`references.md`](./references.md)를 단일 레퍼런스 북으로 두고, H0a 완료 전에는 `harness/` 구현을 하지 않는다. 차용 여부는 §4 매트릭스 + ADR로만 확정한다.
- **대안**: Superpowers/BMAD 플러그인 설치(기각 — “만들어 쓰기” 목표)
- **결과**: —

---

## ADR-006 — 작은 변경 Quick Flow (H0a)

- **상태**: Accepted (2026-05-19)
- **맥락**: BMAD Quick Flow vs Full; H0a 질문 1.
- **결정**: **A** — 오타·한 줄 버그·범위가 명확한 단일 수정은 `plan.md`·「구현해」 워크플로 **생략 가능**. 단, 레이어/import·Factory·새 API 등 **구조 변경**은 항상 Full(플랜 게이트).
- **대안**: B — 모든 변경에 plan 필수
- **결과**: H1 `vision.md` §예외에 반영

---

## ADR-007 — 워크플로 단계 분리 (H0a)

- **상태**: Accepted (2026-05-19)
- **맥락**: gstack gear-shifting; H0a 질문 2; vision §고통 3(일관성).
- **결정**: **단계를 나눈다.** 1인 개발용 최소 5모드(이름은 H1에서 한국어 트리거와 함께 확정):
  1. **intake** — 요구·범위·완료 정의
  2. **plan** — `plan.md` (Before/After)
  3. **implement** — 승인 후 코드
  4. **verify** — 리뷰·테스트·레이어 점검
  5. **ship** — 커밋·PR (명시 시만)
- **대안**: plan + implement 2단만
- **결과**: H1에서 `docs/harness/workflows/00-triggers.md` 초안 작성

---

## ADR-008 — 테스트·TDD (H0a)

- **상태**: Accepted (2026-05-19)
- **맥락**: Superpowers TDD; H0a 질문 3.
- **결정**: **차용** — 하네스에 테스트 단계를 넣는다. iOS 현실에 맞게 **완화 적용**:
  - **verify** 단계: 변경에 테스트가 있으면 실행·실패 시 완료 선언 금지
  - **implement** 단계: plan에 테스트 항목이 있으면 RED→GREEN 순서 권장 (UI-only·테스트 없는 모듈은 plan에 “수동 검증” 명시)
  - Superpowers급 “모든 코드 전 테스트 필수”는 **하지 않음** — ADR-008b로 H3 dogfood 후 조정 가능
- **대안**: 보류(기각)
- **결과**: H4 `04-verify.md`·H3 실험 시 `friction-log.md`에 기록

---

## ADR-009 — 세션 상태 디렉터리 (H0a)

- **상태**: Accepted (2026-05-19)
- **맥락**: OMX `.omx/`; H0a 질문 4.
- **결정**: **`harness/state/`** (또는 H2에서 확정한 동등 경로)를 둔다. **gitignore** — 막힌 점·중간 가설·세션 메모만. `docs/plans/`·ADR·plan.md와 **역할 분리** (state는 커밋 안 함).
- **대안**: state 없음, 채팅만
- **결과**: H2 디렉터리 확정 시 `.gitignore` 추가

---

## ADR-010 — plan.md 형식 (H0a)

- **상태**: Accepted (2026-05-19)
- **맥락**: Superpowers 2–5분 태스크 vs Souzip Before/After; H0a 질문 5; vision §고통 1(플랜 가독성).
- **결정**: **유지** — 파일별 **Before/After** 중심 `plan.md`. Superpowers식 초소단위 태스크 분해는 **하지 않음**.
- **대안**: 2–5분 태스크 단위 쪼개기
- **결과**: H3 이후 **플랜 가독성** 개선은 별도 ADR·템플릿 실험(vision 고통 1) — 형식 자체는 유지

---

## ADR-013 — docs 일원화 · LHE A~E · gitignore (2026-05)

- **상태**: Accepted
- **맥락**: LHE 구조 채택(A~E); `harness/` 루트 분산; `docs/plans/` 전체 gitignore로 SoR 불가.
- **결정**:
  - 하네스 본문 → **`docs/harness/`** (progress, workflows, scripts, templates)
  - 기능 산출물 → **`docs/plans/{feature}/`** (git **추적**)
  - LHE A~E 반영: progress, feature-tracker, DoD, preflight, 5모드 합성
  - 임시 메모만 **`docs/harness/scratch/`** gitignore
  - 추후 선택 ignore → [`docs/harness/gitignore-policy.md`](../../harness/gitignore-policy.md)
  - ADR-009 `harness/state/` → **`docs/harness/scratch/`** (역할 동일, 경로만 변경)
- **대안**: 루트 `harness/` 유지 · plans 계속 ignore
- **결과**: 루트 `harness/` 삭제. H3 dogfood는 새 경로 사용.

---
