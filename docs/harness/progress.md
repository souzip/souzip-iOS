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
| Current blocker | _(없음 / 한 줄)_ |
| Working directory | `~/work/souzip/SOU-637-agent-harness-rebuild` |
| SOZIP_MAIN_REPO | `/Users/parkjuseng/MySpace/Projects/사이드프로젝트_Souzip/Souzip` |
| Branch | `chore/SOU-637/agent-harness-rebuild` |

---

## Session Records

<!-- 세션 종료마다 위에 최신 항목 추가. 오래된 것은 삭제해도 됨. -->

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
