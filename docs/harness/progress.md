# Souzip — 진행 로그 (progress)

> LHE `claude-progress.md` 대응. **세션·검증 상태 SSOT.**  
> 새 Cursor 채팅 시작 시 **이 파일을 먼저** 읽는다.

---

## Current Verified State

| 항목 | 값 |
|------|-----|
| Repository root | `Souzip/` (Tuist iOS) |
| Standard install | `tuist install` |
| Standard verify (기준선) | `docs/harness/scripts/preflight.sh` |
| Standard start | Xcode → `*.xcworkspace` (tuist generate 후) |
| Highest priority unfinished | [SOU-637](https://souzip.atlassian.net/browse/SOU-637) AI 하네스 · `docs/plans/agent-harness-rebuild/` |
| Current blocker | H3 dogfood·Cursor smoke 미실행 (harness-improvement 루프 문서화 완료) |
| Working directory | `/Users/parkjuseng/MySpace/Projects/사이드프로젝트_Souzip/Souzip` (worktree **없음**) |
| SOZIP_MAIN_REPO | _(미사용 — branch-only)_ |
| Branch | `feat/domain-module-tests` (Jira 키 확보 후 `feat/SOU-XXX/domain-module-tests`로 rename 권장) |
| Active plan | `docs/plans/domain-module-tests/plan.md` |

---

## Session Records

<!-- 세션 종료마다 위에 최신 항목 추가. 오래된 것은 삭제해도 됨. -->

### 2026-05-25 — domain-module-tests start (branch-only)

| 필드 | 내용 |
|------|------|
| **Goal** | Jira 스토리 + 브랜치 준비 (`souzip-start`, worktree **생략**) |
| **Completed** | `git checkout -b feat/domain-module-tests` from `origin/develop` · 미커밋 DomainTests·Tuist 변경 유지 |
| **Jira** | **미생성** — MCP `atlassian` 없음 · Summary 초안 plan 상단 · 웹 생성 후 `SOU-XXX` 알려주면 plan·`git branch -m` 반영 |
| **Verification run** | preflight (start 후) |
| **Next best action** | Jira 웹 생성 또는 MCP 연결 → `커밋해` (Tests/plan vs Tuist 분리) |

### 2026-05-25 — domain-module-tests verify (현재 범위)

| 필드 | 내용 |
|------|------|
| **Goal** | `docs/plans/domain-module-tests/plan.md` — UseCase 32개 각 ≥1 test · Sources 변경 없음 |
| **Completed** | DomainTests **45/0** · Mocks 7+Onboarding · `DomainTestFixtures` · `Projects/Domain/Sources/**` diff **0** |
| **Verification run** | preflight OK · `xcodebuild test -workspace Souzip.xcworkspace -scheme Domain -destination 'platform=iOS Simulator,name=iPhone 13 mini' -only-testing:DomainTests` **45/0** (2026-05-25) · Tests `!`/IUO/Combine/Data/Presentation import grep 0 |
| **Evidence** | plan §완료 기준 [x] · 인벤토리 **32/32** ✅ · Model/Error 단독 테스트 없음 (plan 비목표 준수) |
| **Known risks** | 워킹 트리에 **domain-first-tests** Tuist 스킴 변경 혼재 — `domain-module-tests` 커밋과 **분리** 권장 · ⌘U는 **`Domain`** 또는 **`수집-Tests`** 사용 |
| **Commits** | 없음 |
| **Next best action** | `커밋해` (Domain Tests+plan / Tuist 분리) |

### 2026-05-24 — domain-module-tests verify (구 기록)

| 필드 | 내용 |
|------|------|
| **Goal** | Domain UseCase 33 전수 단위 테스트 (구 plan; `LoadUserWishlists` 제외 후 32) |
| **Completed** | DomainTests 46건 (당시) · plan 정합 2026-05-25에 45건·32 UseCase로 수정 |
| **Verification run** | preflight OK · Domain scheme 46/0 (2026-05-24) |
| **Evidence** | superseded by 2026-05-25 verify 위 |

### 2026-05-24 — harness-improvement 루프 implement

| 필드 | 내용 |
|------|------|
| **Goal** | 이벤트 기반 하네스 마찰 기록·개선 절차 (`docs/plans/harness-improvement/plan.md`) |
| **Completed** | `friction-log.md`, `workflows/02-harness-improvement.md`, `00-triggers` §3.1·§6, `01-session-lifecycle`, README·AGENTS·Rule |
| **Verification run** | plan §완료 기준 전항목 · `git diff Projects/` 없음 · **verify 2026-05-24** (triggers·링크·02=부록 A) |
| **Evidence** | `docs/harness/friction-log.md` 첫 행(조치) · plan 체크박스 [x] · verify 통과 |
| **Commits** | 없음 |
| **Next best action** | `커밋해`(docs/harness) 또는 실제 기능 dogfood 후 friction 한 줄 |

### 2026-05-22 — SOU-637 하네스 정합성 보정

| 필드 | 내용 |
|------|------|
| **Goal** | 하네스 구조 다이어트가 아니라, 깨진 링크·정책 충돌·stale 상태·preflight 환경 문제 수정 |
| **Completed** | `triggers.md` 정본 참조를 `docs/harness/workflows/00-triggers.md`로 정리 · Jira MCP 정책을 Cursor 플러그인 우선/로컬 `.cursor/mcp.json` 선택으로 통일 · H3/H4/H5 상태를 “초안 선행 + dogfood/smoke 미완료”로 보정 · `preflight.sh`에 `mise exec -- tuist` fallback 추가 |
| **Verification run** | 링크/문구 `rg` 점검 · `docs/harness/scripts/preflight.sh` OK (`tuist install` + `tuist generate`) |
| **Evidence** | 수정 파일: `AGENTS.md`, `.cursor/rules/00-souzip-harness.mdc`, `.cursor/skills/souzip-*`, `docs/harness/jira-mcp-setup.md`, `docs/harness/scripts/preflight.sh`, `docs/plans/agent-harness-rebuild/{decisions,milestones,vision}.md` |
| **Commits** | 없음 |
| **Known risks** | `.mise.toml`에 기존 uncommitted task 변경 있음 · H3 dogfood / Cursor 새 채팅 smoke 미실행 · sandbox 안 preflight는 Tuist 홈 로그 권한으로 실패 가능 |
| **Next best action** | 리뷰 단위 `커밋해` 또는 H3 dogfood 작업 1건 선정 |

### 2026-05-19 — SOU-637 하네스 스토리 생성

| 필드 | 내용 |
|------|------|
| **Goal** | Jira 스토리 생성 (A안 Summary) |
| **Completed** | [SOU-637](https://souzip.atlassian.net/browse/SOU-637) 생성 · Sprint 16 · Assignee 본인 |
| **Next best action** | worktree Open Folder · preflight · 리뷰 단위 `커밋해` |

### 2026-05-19 — SOU-637 worktree 시작

| 필드 | 내용 |
|------|------|
| **Goal** | worktree + `chore/SOU-637/agent-harness-rebuild` |
| **Completed** | `~/work/souzip/SOU-637-agent-harness-rebuild` · WIP stash→pop · Config 복사 |
| **Verification run** | preflight — 샌드박스에서 `tuist` PATH 없음 → 로컬 재실행 |
| **Next best action** | 리뷰 단위 `커밋해` (불필요 파일 정리 완료) |

### 2026-05-19 — SOU-637 커밋 전 정리

| 필드 | 내용 |
|------|------|
| **Completed** | `.cursor/mcp.json`·`settings.json` 제거 · 무관 `docs/plans/*` 14폴더 삭제 · `plans/**/*.html` gitignore |
| **Next best action** | `커밋해` (harness / workflow-plans / cursor-skills 분리) |

### YYYY-MM-DD — (세션 제목)

| 필드 | 내용 |
|------|------|
| **Goal** | |
| **Completed** | |
| **Verification run** | 예: preflight OK, Xcode build scheme … |
| **Evidence** | 예: plan §완료 기준 2/3, feature-tracker `evidence` |
| **Commits** | _(해시 또는 “없음”)_ |
| **Known risks** | |
| **Next best action** | |
