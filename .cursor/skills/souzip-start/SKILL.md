---
name: souzip-start
description: >
  Souzip 작업 시작. 트리거: 작업 시작, 브랜치 만들어, worktree 만들어, Jira 스토리.
  Jira MCP 필수. ~/work/souzip worktree, preflight. commit/PR 금지(G4).
---

# Souzip — start

정본: `docs/plans/workflow-skills-jira-git/worktree-start-flow.md` · `jira-story-format.md`

## 게이트

- **Jira MCP 필수** — 없으면 **중단** → `docs/harness/jira-mcp-setup.md` (플러그인 우선)
- **G4**: 이 모드에서 commit / push / `gh pr` **금지**
- **작업 루트**: 이후 implement·commit·PR은 **worktree cwd** (`progress.md` 기록)

## 경로 (C — 고정 루트)

```text
~/work/souzip/main/                          # SOZIP_MAIN_REPO
~/work/souzip/{SOU-KEY}-{slug}/              # worktree
```

| 변수 | 기본 |
|------|------|
| `SOZIP_WORK_ROOT` | `~/work/souzip` |
| `SOZIP_MAIN_REPO` | `~/work/souzip/main` |

`main` 없으면 clone 안내 후 worktree **보류**. 기존 `…/Souzip` 클론 → `SOZIP_MAIN_REPO`만 지정 가능 (`progress.md` 기록).

## 흐름

1. **MCP 게이트** — 실패 시 setup만, 성공 시 계속
2. **Jira**
   - **신규**: `jira-story-format.md` → 확인 표 → `createJiraIssue` → `SOU-XXX`
   - **기존 키**: 조회만
   - **비상**: MCP 불가 + 사용자가 키 직접 입력
3. **slug** — kebab-case · `docs/plans/{feature-slug}/` 와 맞추기
4. **git**

```bash
export SOZIP_WORK_ROOT="${SOZIP_WORK_ROOT:-$HOME/work/souzip}"
export SOZIP_MAIN_REPO="${SOZIP_MAIN_REPO:-$SOZIP_WORK_ROOT/main}"
WT_PATH="$SOZIP_WORK_ROOT/${JIRA_KEY}-${slug}"
BRANCH="feat/${JIRA_KEY}/${slug}"

cd "$SOZIP_MAIN_REPO"
git fetch origin develop
git worktree add "$WT_PATH" -b "$BRANCH" origin/develop
cd "$WT_PATH"
```

5. **Tuist** — Config 없으면 `cp Config/Example.xcconfig` → `Debug.xcconfig` (Release 동일)
6. **preflight** — worktree 루트에서 `docs/harness/scripts/preflight.sh`
7. **기록** — `docs/harness/progress.md`: Jira, 브랜치, **Working directory**, plans 경로
8. **작업 루트** — `cd "$WT_PATH"` 필수 · Cursor는 **Open Folder** (선택)
9. **plan** — `docs/plans/{feature-slug}/plan.md` 없으면 제안 (G1 — 구현은 승인 후)

## 옵션

- **`--branch-only` / `--no-worktree`**: `git checkout -b feat/SOU-XXX/slug` 만 (현재 cwd)

## 라우팅

- plan → `souzip-plan`
- 구현 → `souzip-implement`
- 커밋 / PR → `souzip-commit` · `souzip-pr`
