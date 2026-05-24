# Jira · worktree · commit · PR 스킬 (리서치 및 구현 계획)

> **민감 정보 금지**: API 키·Jira 토큰·실계정은 plan/커밋에 넣지 않는다.  
> MCP·자격 증명은 Cursor 설정·환경 변수만.

## intake 결과 (확정)

| 항목 | 결정 |
|------|------|
| Jira | **Atlassian MCP 필수** — 미연결 시 연결 가이드 후 중단 ([`jira-mcp-setup.md`](../../harness/jira-mcp-setup.md)) |
| Git | **기본 worktree** · 필요 시 브랜치만 (`--no-worktree`) |
| worktree 위치 | **C — 고정 루트** `~/work/souzip/` (intake 확정) |
| 브랜치명 | `constitution`: `<type>/<JIRA-ID>/<설명>` (예: `feat/SOU-398/nickname-policy`) |
| PR | base `develop`, 제목 `[SOU-XXX] …`, Co-Authored-By 없음 |
| 적용 순서 | ① `souzip-commit` ② `souzip-pr` ③ `souzip-start` (+ MCP) |
| 커밋 단위 | **①** PR 안 여러 커밋 = 레이어·plan §·리뷰 1회 분량 · **②** 사용자가 범위 지정 시 스테이징·메시지·커밋만 수행 |

## 목표

하네스 5모드·G4에 맞게 **ship을 쪼개고**, 작업 시작(Jira+worktree)을 자동화 가능한 스킬로 둔다.

## 비목표

- Jira Cloud 앱·서버 직접 구현
- MCP 없을 때 **웹 수동을 기본 경로로 두지 않음** (연결 setup만 안내)
- `souzip-ship` 즉시 삭제 (당분간 얇은 라우터로 유지)
- `~/work/souzip/` 외 경로를 스킬에서 자동 탐색·이전 (경로는 `progress`·환경 변수로만 오버라이드)

---

## 파악한 구조

- 기존: `.cursor/skills/souzip-ship` — 커밋+PR 통합, G4
- 정본: `docs/harness/workflows/00-triggers.md`, `constitution.md` §Git
- Jira MCP: [`.cursor/mcp.json`](../../../.cursor/mcp.json) 추가 — **사용자 OAuth·Enable 필요** ([`jira-mcp-setup.md`](../../harness/jira-mcp-setup.md))
- Tuist: worktree마다 `tuist install` / `tuist generate` 필요 (`preflight.sh`)

### Tuist · worktree · gitignore (참고)

- **`.gitignore` 규칙 자체**는 worktree에서도 동일하게 적용된다 (같은 Git 저장소).
- “적용 안 되는 것처럼” 보이는 경우는 대부분 **git에 없는 로컬 파일**:
  - `Config/Debug.xcconfig`, `Release.xcconfig` — `Example.xcconfig`에서 **worktree마다 복사** 필요
  - `Derived/`, `.tuist/` — generate 후 생성·ignore (worktree별 독립)
- **start 스킬 DoD**: worktree 루트에서 `git check-ignore -v Config/Debug.xcconfig` 또는 Config 존재 확인 + `preflight.sh`

### worktree 경로 — **C: 고정 루트** (확정)

```text
~/work/souzip/
├── main/                      # 메인 클론 (develop 체크아웃, 최초 1회)
└── SOU-398-nickname-policy/   # worktree (feat/SOU-398/nickname-policy)
```

| 변수 | 기본값 | 용도 |
|------|--------|------|
| `SOZIP_WORK_ROOT` | `~/work/souzip` | worktree 부모 (오버라이드 가능) |
| `SOZIP_MAIN_REPO` | `~/work/souzip/main` | `git worktree add` 기준 repo |

**최초 1회** (메인 클론이 없을 때):

```bash
mkdir -p ~/work/souzip
git clone <remote-url> ~/work/souzip/main
cd ~/work/souzip/main && git checkout develop
```

**스토리 시작** (start 스킬):

```bash
export SOZIP_WORK_ROOT="${SOZIP_WORK_ROOT:-$HOME/work/souzip}"
export SOZIP_MAIN_REPO="${SOZIP_MAIN_REPO:-$SOZIP_WORK_ROOT/main}"
WT_PATH="$SOZIP_WORK_ROOT/${JIRA_KEY}-${slug}"
BRANCH="feat/${JIRA_KEY}/${slug}"

cd "$SOZIP_MAIN_REPO"
git fetch origin develop
git worktree add "$WT_PATH" -b "$BRANCH" origin/develop
cd "$WT_PATH"
# Config 없으면: cp Config/Example.xcconfig → Debug.xcconfig (Release 동일)
docs/harness/scripts/preflight.sh
```

- **Cursor**: 이후 작업은 **`$WT_PATH`를 워크스페이스로 연다** (메인 `Souzip/`과 혼동 방지).
- 기존 로컬 클론(`…/Souzip`)은 `main`으로 쓰거나, `SOZIP_MAIN_REPO`만 그 경로로 지정해도 됨 (`progress.md`에 기록).

---

## 변경 계획

### 1. `souzip-commit` (우선)

**파일**: `.cursor/skills/souzip-commit/SKILL.md` (신규)

**커밋 철학 (intake 확정 ①+②)**

| | 내용 |
|---|------|
| **①** | PR 1개 안에 **여러 커밋**. 한 커밋 = plan §·레이어·**리뷰 1회**에 설명 가능한 크기 (전체 working tree 한 방 ❌) |
| **②** | 사용자가 **「이번 커밋은 ~만」** 범위를 지정하면, AI는 **스테이징 + 메시지 + 커밋**만 (범위 재해석·추가 구현 ❌) |

**트리거**

- 「커밋해」— 범위 **없으면** 아래 제안 흐름
- 「Domain만 커밋해」「docs만 커밋」「이번 커밋은 PresentationFactory만」— **②** 즉시

**범위 없을 때 흐름 (①)**

1. `git status` / `git diff` (staged·unstaged 구분)
2. **리뷰 단위 후보** 1~3개 제안 (파일 목록 + 한 줄 + `type` 후보)
   - 예: Domain만 / Data만 / docs만 / 한 화면+Factory
3. 사용자 선택·수정 대기 (**자동 `git add -A` 금지**)
4. 선택 범위만 `git add` (경로·또는 `git add -p` 안내)
5. 메시지 초안 `<type>: <한국어 한 줄>` → 확인 후 HEREDOC 커밋
6. 남은 변경 있으면 “다음 리뷰 단위” 안내 — **연속 2번째 커밋은 사용자 다음 지시 전까지 안 함**

**공통**

- G4: 「커밋해」 등 **명시** 시만
- body·Co-Authored-By 없음
- **worktree** (`~/work/souzip/...`)면 `pwd`가 해당 worktree 루트인지 확인
- Full Flow 코드: **verify 통과 분량** 커밋 권장 (미검증이면 1줄 경고, 사용자 “그래도” 시 진행)
- plan·코드 **항상 분리** (`docs:` vs `feat`/`fix` — 한 커밋에 합치지 않음)

### 2. `souzip-pr`

**파일**: `.cursor/skills/souzip-pr/SKILL.md` (신규)

- 트리거: 「PR 만들어줘」
- Ready for review (**`--draft` 없음**)
- 제목 `[SOU-XXX] …` · 본문 [`.github/pull_request_template.md`](../../../.github/pull_request_template.md) + [`pr-body.md`](../../harness/templates/pr-body.md)
- `gh pr create --base develop` · 필요 시 push 포함

### 3. `souzip-start` (Jira + worktree)

**파일**: `.cursor/skills/souzip-start/SKILL.md` (신규)

- 트리거: 「작업 시작」「브랜치 만들어」「worktree 만들어」, Jira 키+기능 설명
- 흐름:
  1. **Jira MCP 게이트** — 없으면 **중단** → 플러그인·[`jira-mcp-setup.md`](../../harness/jira-mcp-setup.md)  
     신규: [`jira-story-format.md`](jira-story-format.md) — summary·필드·확인 표  
     기존 키: 조회만 → worktree  
     **비상만**: MCP 불가 시 키 직접 입력
  2. **slug** — 한 줄 설명 kebab-case
  3. **git** — `feat/SOU-XXX/slug` + worktree → `$SOZIP_WORK_ROOT/SOU-XXX-slug` (C)
  4. **Tuist** — Config 복사 안내/검사, `preflight.sh` (worktree 루트)
  5. **기록** — `progress.md`: `Working directory`(worktree), 브랜치, plans 경로
  6. **작업 루트** — **worktree에서 `cd`** (필수). Cursor는 폴더 열기(선택). 추후 CLI 동일 — [`worktree-start-flow.md`](worktree-start-flow.md)
  7. **plan** — `docs/plans/{feature-slug}/plan.md` 제안
- 옵션: `--branch-only` → worktree 없이 브랜치만
- **금지**: 이 모드에서 commit / PR (G4)

### 4. `souzip-ship` (얇게)

- commit → `souzip-commit`, PR → `souzip-pr` 위임 안내만 유지 (하위 호환)

### 5. 하네스 정본

| 파일 | 변경 |
|------|------|
| `docs/harness/workflows/00-triggers.md` | §3 트리거·스킬 표에 start/commit/pr |
| `.cursor/rules/00-souzip-harness.mdc` | 모드 표 갱신 |
| `docs/harness/context/feature-playbook.md` | (선택) worktree 1줄 |

### 6. Jira MCP (구현 전 필수 — 사용자)

- [x] [`.cursor/mcp.json`](../../../.cursor/mcp.json) (Atlassian `mcp-remote`)
- [ ] Cursor MCP에서 **Enable** + 재시작 + OAuth
- [ ] 연결 확인 (Jira 검색 1회)
- 가이드: [`docs/harness/jira-mcp-setup.md`](../../harness/jira-mcp-setup.md)

---

## 완료 기준

- [x] `.cursor/skills/souzip-commit`, `souzip-pr`, `souzip-start` 존재
- [x] `00-triggers.md` · `00-souzip-harness.mdc` 트리거 표 일치
- [ ] `souzip-start`에 MCP 폴백·`~/work/souzip/`·Config·preflight 명시
- [ ] `souzip-commit`이 ① 제안·② 범위 지정·부분 `git add`를 문서화
- [ ] (검증) docs만 / skills만 등 **리뷰 단위 1~2커밋**으로 dogfood
- [ ] (선택) 실제 worktree 1개 생성 수동 테스트 — 사용자 「구현해」 후

---

## 참고

- 브랜치 예: `feat/SOU-398/nickname-policy`
- start 스킬: MCP 게이트 → 실패 시 setup만, 성공 시 MCP create + worktree
- 메인 클론을 아직 `~/work/souzip/main`에 안 두었다면 최초 1회 clone 또는 `SOZIP_MAIN_REPO` 지정
