# worktree · 작업 시작 흐름 (intake 확정)

> **스토리 규칙**: [`jira-story-format.md`](jira-story-format.md)  
> **구현 스킬**: `.cursor/skills/souzip-start`  
> **환경**: 지금 **Cursor** · 추후 터미널 Agent 등 **미정** → 아래는 **도구 중립** (작업 루트 = worktree)

---

## 원칙

| 원칙 | 설명 |
|------|------|
| **작업 루트** | Git·Tuist·Agent·plan은 **worktree 디렉터리** 기준 (main/예전 Souzip 경로에서 implement 금지) |
| **경로** | `~/work/souzip/{SOU-KEY}-{slug}/` ([`plan.md`](plan.md) § C) |
| **IDE vs CLI** | **필수 동작은 `cd` worktree** · IDE “새 창”은 **선택** |
| **Jira** | MCP 필수 · 스토리 형식은 `jira-story-format.md` |

---

## 경로

```text
~/work/souzip/
├── main/                    # SOZIP_MAIN_REPO, develop
└── SOU-633-wishlist-.../    # 이번 티켓 (브랜치 feat/SOU-633/slug)
```

| 변수 | 기본 |
|------|------|
| `SOZIP_WORK_ROOT` | `~/work/souzip` |
| `SOZIP_MAIN_REPO` | `~/work/souzip/main` |

`main` 없으면 clone 안내 후 worktree 보류. 기존 클론을 main으로 쓸 때는 `export SOZIP_MAIN_REPO=/path/to/Souzip` (`progress.md`에 기록).

---

## 흐름 (공통)

1. **MCP 게이트** — 없으면 중단 · [Jira MCP 가이드](../../harness/jira-mcp-setup.md) (플러그인 우선)
2. **Jira**
   - **신규**: `jira-story-format.md` → 확인 표 → `createJiraIssue` → `SOU-XXX`
   - **기존 키**: 조회만
3. **slug** — `docs/plans/{feature-slug}/` 와 맞추기 권장
4. **git** — `git worktree add $WT -b feat/SOU-XXX/slug origin/develop`
5. **Tuist** — worktree에서 Config 복사(필요 시) · `docs/harness/scripts/preflight.sh`
6. **기록** — `progress.md`: Jira 키, 브랜치, **`Working directory: $WT`**, plans 경로
7. **작업 루트 고정** — 아래 “환경별” 중 하나

---

## 환경별 — 작업 루트 맞추기

**공통 필수 (지금·나중 모두):**

```bash
cd ~/work/souzip/SOU-633-wishlist-toggle-mypage-grid
```

| 환경 | 권장 (추가) | 비고 |
|------|-------------|------|
| **Cursor IDE** (지금) | **File → Open Folder** → worktree 경로 | 예전 `…/Souzip` 창에 남아 implement 하지 않기 |
| **Cursor Agent CLI** (추후) | worktree에서 `agent` / 해당 cwd | `AGENTS.md`·skills 동일 |
| **기타 터미널 Agent** (추후) | 동일 `cd` | 하네스는 레포 파일만 의존 |

**하지 않기:** worktree만 `cd`하고 Agent/IDE는 **main·옛 Souzip** 루트 유지 (브랜치·파일 불일치).

---

## 예시 — SOU-633 (기존 스토리)

```bash
cd ~/work/souzip/main && git fetch origin develop
git worktree add ~/work/souzip/SOU-633-wishlist-toggle-mypage-grid \
  -b feat/SOU-633/wishlist-toggle-mypage-grid origin/develop
cd ~/work/souzip/SOU-633-wishlist-toggle-mypage-grid
cp Config/Example.xcconfig Config/Debug.xcconfig
cp Config/Example.xcconfig Config/Release.xcconfig
docs/harness/scripts/preflight.sh
```

- plans: `docs/plans/wishlist-toggle-mypage-grid/plan.md` (있으면) 또는 slug 폴더 제안  
- Cursor: 위 폴더를 워크스페이스로 열기  
- 다음: `souzip-plan` → 승인 → implement

---

## 예시 — 신규 스토리 + start

1. 스토리 생성 (`jira-story-format.md`) → SOU-634  
2. 위와 동일, `SOU-634-notification-badge` worktree · `feat/SOU-634/notification-badge`  
3. `docs/plans/notification-badge/plan.md` 제안 (plan 상단 Jira 링크)

---

## 옵션

| 플래그 | 동작 |
|--------|------|
| (기본) | worktree + `cd` 안내 |
| `--branch-only` | worktree 없이 `main`에서 브랜치만 |

---

## 실패 시

| 상황 | 동작 |
|------|------|
| worktree 경로 존재 | 재생성 X · 기존 경로 + 브랜치 확인 |
| preflight 실패 | G0 · 복구 전 implement X |
| MCP 없음 | Jira·worktree 모두 보류 |

---

## 변경 이력

| 날짜 | 내용 |
|------|------|
| 2026-05 | C 경로 · MCP · 터미널/IDE 중립(cwd=worktree) |
