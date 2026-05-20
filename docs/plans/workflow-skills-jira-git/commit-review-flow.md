# 커밋 규칙 · 리뷰 단위 (`souzip-commit`)

> **구현 스킬**: `.cursor/skills/souzip-commit` · **G4**  
> **분리**: PR·push는 `souzip-pr` / 기존 `souzip-ship`은 라우터만  
> **작업 루트**: worktree `cwd` ([`worktree-start-flow.md`](worktree-start-flow.md))

---

## 철학 (intake 확정)

| | 내용 |
|---|------|
| **①** | PR 하나에 **커밋 여러 개**. 한 커밋 = plan § · 레이어 · **리뷰 1회**로 설명 가능 |
| **②** | 「docs만 커밋해」처럼 **범위 지정** 시 → 스테이징·메시지·커밋만 (코드 추가·범위 확대 ❌) |

**하지 않음:** `git add -A` 기본 · 확인 없이 연속 2커밋 · push · PR

---

## 게이트

- **G4**: 「커밋해」「~만 커밋해」 등 **명시** 시만
- **cwd**: `git rev-parse --show-toplevel` = worktree (의도한 티켓 경로; `progress.md`와 대조)
- **코드 커밋**: verify 통과·plan 범위 권장 — 미충족 시 1줄 경고, 사용자 「그래도」 시 진행
- **docs-only**: verify 생략 가능

---

## 커밋 메시지

```text
<type>: <한국어 한 줄>
```

| type | 용도 |
|------|------|
| feat | 기능 |
| fix | 버그 |
| refactor | 동작 동일 구조 |
| docs | 문서만 |
| chore | 설정·스크립트 |
| test | 테스트 |

- **body 없음** · **Co-Authored-By 없음**
- Jira 키는 **브랜치·PR 제목**에 (`feat/SOU-633/...`, `[SOU-633] …`) — 커밋 제목에 `[SOU-633]` **넣지 않음** (기존 레포 관례)

---

## 흐름

### A. 「커밋해」만 (범위 없음)

1. `git status` · `git diff` · `git log -3 --oneline`
2. **리뷰 단위 후보** 1~3개 제안 (경로 목록 + type 후보 + 메시지 초안)
3. 사용자 선택·수정 **대기**
4. **선택 경로만** `git add` (`git add -p` 안내 가능)
5. 메시지 확인 → HEREDOC `git commit`
6. `git status` — **남은 변경** 있으면 “다음 리뷰 단위” 안내 (**자동 2커밋 X**)

### B. 「docs/harness만 커밋해」 (범위 있음 ②)

1. status/diff — **해당 경로만** 필터
2. 범위·메시지 초안 1개 → 확인
3. `git add` (지정 paths only) → commit
4. 남은 변경 안내

---

## 예시 — 하네스 문서만 (지금 레포)

**상태:** `docs/harness/`, `docs/plans/workflow-skills-jira-git/`, `.cursor/mcp.json`, `AGENTS.md` 등 수정, `Projects/` 코드는 무관

**AI 제안 (①):**

| # | 범위 | 메시지 초안 |
|---|------|-------------|
| 1 | `docs/harness/`, `docs/README.md`, `AGENTS.md`, `.gitignore` | `docs: 하네스 context·plans gitignore 정책` |
| 2 | `docs/plans/workflow-skills-jira-git/` | `docs: Jira·worktree·커밋 플로우 intake 정리` |
| 3 | `.cursor/mcp.json` (있다면) | `chore: Atlassian MCP 설정` — 플러그인만 쓰면 **제외** |

**당신:** 「1번만」

**실행:**

```bash
git add docs/harness docs/README.md AGENTS.md .gitignore  # 1번에 합의된 paths만
git commit -m "$(cat <<'EOF'
docs: 하네스 context·plans gitignore 정책
EOF
)"
```

---

## 예시 — 기능 PR (SOU-633 worktree)

**상태:** Domain+Data 완료, Presentation 일부, plan.md 수정됨

**AI 제안:**

| # | 범위 | 메시지 |
|---|------|--------|
| 1 | `Projects/Domain/.../Wishlist/`, `Projects/Data/.../Wishlist/`, Factory | `feat: 위시리스트 Domain·Data 레이어` |
| 2 | `Projects/Presentation/.../MyPage/...` | `feat: 마이페이지 찜 탭 UI` |
| 3 | `docs/plans/wishlist-mypage-grid/plan.md` | `docs: SOU-633 plan 체크리스트 갱신` |

**순서:** 1 → 3 → 2 (plan 커밋은 코드와 **절대 합치지 않음**)

---

## 예시 — 잘못된 커밋 (금지)

| 요청/동작 | 왜 안 됨 |
|-----------|----------|
| 「커밋해」→ `git add -A` | ① 위반 |
| Domain+Presentation 한 커밋 | 리뷰·revert 어려움 |
| 확인 없이 3커밋 연속 | ②·G4 |
| `fix: 버그` (영어 설명) | 한국어 한 줄 규칙 |
| 커밋 메시지에 API 키 | 민감정보 |

---

## plan.md와의 관계 (intake 확정: **항상 분리**)

| | 규칙 |
|---|------|
| **코드** | `feat` / `fix` / `refactor` … — `Projects/` 등 |
| **plan** | **별도 커밋** · `docs:` — `docs/plans/{feature}/` 만 |

- plan + 코드를 **한 커밋에 넣지 않음** (제안 표에서도 항목 분리)
- plan 체크만 갱신해도 `docs: …` 단독 커밋
- implement 범위 밖 파일 → 커밋 전 1줄 경고

---

## `souzip-ship`과의 관계

| 트리거 | 스킬 |
|--------|------|
| 커밋해 / ~만 커밋 | **souzip-commit** |
| PR 만들어줘 | **souzip-pr** (추후) |
| ship (모호) | ship → commit/pr 중 어디인지 1줄 질문 |

---

## 변경 이력

| 날짜 | 내용 |
|------|------|
| 2026-05 | ①② intake · 리뷰 단위 · G4 · worktree cwd |
