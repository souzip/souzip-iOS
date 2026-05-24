---
name: souzip-commit
description: >
  Souzip 커밋(G4). 트리거: 커밋해, ~만 커밋해, docs만 커밋.
  리뷰 단위 제안·부분 git add. git add -A 금지. plan·코드 분리 커밋.
  연속 2커밋·push·PR 금지.
---

# Souzip — commit

정본: `docs/plans/workflow-skills-jira-git/commit-review-flow.md` · G4

## 게이트

- **G4**: 「커밋해」「~만 커밋해」 등 **명시** 없으면 `git commit` **금지**
- **cwd**: `git rev-parse --show-toplevel` — worktree면 `progress.md`의 Working directory와 일치 확인
- **금지**: `git add -A` 기본 · 확인 없이 **연속 2커밋** · push · `gh pr`
- **plan·코드 분리**: `docs:` vs `feat`/`fix` — **한 커밋에 합치지 않음**

## 메시지

```text
<type>: <한국어 한 줄>
```

- body·Co-Authored-By 없음
- 커밋 제목에 `[SOU-XXX]` **넣지 않음** (브랜치·PR 제목에만)

HEREDOC 예:

```bash
git commit -m "$(cat <<'EOF'
docs: 하네스 PR 템플릿 Plan 한 줄 추가
EOF
)"
```

## A. 「커밋해」만 (범위 없음 ①)

1. `git status` · `git diff` · `git log -3 --oneline`
2. **리뷰 단위 후보** 1~3개 (경로 + type + 메시지 초안)
3. 사용자 선택·수정 **대기**
4. **선택 경로만** `git add` (`git add -p` 안내 가능)
5. 메시지 확인 → HEREDOC commit
6. 남은 변경 있으면 “다음 리뷰 단위” 안내 — **자동 2커밋 X**

## B. 범위 지정 (②)

예: 「docs/harness만 커밋해」「PresentationFactory만」

1. status/diff — **지정 범위만**
2. 범위·메시지 초안 1개 → 확인
3. 지정 paths만 `git add` → commit
4. 범위 재해석·추가 구현 **하지 않음**

## 검증

- 코드 커밋: verify 통과·plan 범위 **권장** — 미충족 시 1줄 경고, 사용자 「그래도」 시 진행
- docs-only: verify 생략 가능

## 라우팅

- PR → `souzip-pr`
- 작업 시작·worktree → `souzip-start`
