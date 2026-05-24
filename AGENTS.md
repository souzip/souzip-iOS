# Souzip — AI 에이전트 진입점

**수집(Souzip)**: 여행 기념품 iOS 앱 · Tuist · Swift 5.9 · iOS 16+

목표: 코드만 많이가 아니라 **다음 세션이 추측 없이 이어지게** 저장소를 남긴다 (LHE).

---

## Startup Workflow (세션 시작)

코드 작성 **전**:

1. [`docs/harness/progress.md`](docs/harness/progress.md) — 검증된 상태·다음 액션
2. 작업 feature → [`docs/plans/{feature}/plan.md`](docs/plans/)
3. `git log --oneline -5`
4. implement 예정 → [`docs/harness/scripts/preflight.sh`](docs/harness/scripts/preflight.sh)  
   실패 시 새 기능 중단, 기준선부터

## 읽는 순서 (상세)

1. [`docs/harness/README.md`](docs/harness/README.md) — 4층·LHE A~E
2. [`docs/harness/workflows/00-triggers.md`](docs/harness/workflows/00-triggers.md) — 모드·게이트 (**정본**)
3. [`docs/harness/workflows/01-session-lifecycle.md`](docs/harness/workflows/01-session-lifecycle.md)
4. `.cursor/skills/souzip-*`

## Working Rules

- 한 번에 **하나의 기능** (`feature-tracker` `in_progress` 1개)
- **G1**: plan + 사용자 승인 + 「구현해」/「구현 시작해」 **모두** 전 코드 변경 금지
- **G4**: 「커밋해」「PR」명시 전 commit·push·PR 금지
- 증거 없이 완료·`passing` 표시 금지
- 채팅만 X → `progress` · `plan.md` · `docs/plans/`
- 하네스 마찰 → [`docs/harness/friction-log.md`](docs/harness/friction-log.md) (기록만) · 개선은 「이거 토대로 개선하자」+ plan — [`02-harness-improvement.md`](docs/harness/workflows/02-harness-improvement.md)

## Definition of Done

다음이 **모두**일 때만 기능 완료:

- `plan.md` **§완료 기준** 충족
- 검증 실행 (preflight, plan 테스트, 빌드 등)
- 증거가 `progress` 또는 `feature-tracker.json`에 기록
- preflight로 재시작 가능한 저장소 상태

템플릿: [`docs/harness/templates/plan-dod-section.md`](docs/harness/templates/plan-dod-section.md)

## End of Session

1. `docs/harness/progress.md` 갱신
2. `feature-tracker.json` (있을 때)
3. blocker·Next action 기록
4. (선택) 마찰·회고 → `friction-log.md` 한 행
5. 커밋은 사용자 **ship** 지시 시만

## 비협상

[`docs/harness/constitution.md`](docs/harness/constitution.md)

## 프로젝트·아키텍처

[`docs/harness/context/`](docs/harness/context/)

## 산출물

- `docs/plans/{feature}/` — `plan.md`, (선택) `feature-tracker.json`
- 하네스 메타: `docs/plans/agent-harness-rebuild/`

## Cursor

- Rule: `.cursor/rules/00-souzip-harness.mdc`
- Skills: `.cursor/skills/souzip-*`

## Jira (작업 시작 전)

- Atlassian MCP: Cursor 플러그인 설정 우선 · 로컬 `.cursor/mcp.json`은 선택(커밋 제외) · 연결: [`docs/harness/jira-mcp-setup.md`](docs/harness/jira-mcp-setup.md)
- **미연결 시** `souzip-start`는 setup 안내만 — 웹 수동이 기본이 아님

## Gitignore

- **추적**: `docs/plans/{feature}/plan.md`, (선택) `feature-tracker.json`, `docs/plans/archive/`
- **제외**: `docs/harness/scratch/`, `docs/plans/**/draft-*`, `local-*`, `notes-*`
- 정책: [`docs/harness/gitignore-policy.md`](docs/harness/gitignore-policy.md) · 구조: [`docs/plans/README.md`](docs/plans/README.md)

레거시 `CLAUDE.md` · `.claude/skills/` → H6 제거 ([`docs/harness/migration-map.md`](docs/harness/migration-map.md))
