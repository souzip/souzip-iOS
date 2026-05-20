---
name: souzip-pr
description: >
  Souzip PR(G4). 트리거: PR 만들어줘, PR 생성, PR 올려줘.
  base develop, 제목 [SOU-XXX], Ready for review(--draft 없음).
  본문은 .github/pull_request_template.md + pr-body.md.
---

# Souzip — PR

정본: `docs/plans/workflow-skills-jira-git/pr-review-flow.md` · G4

## 게이트

- **G4**: 「PR 만들어줘」 등 **명시** 없으면 `gh pr` / push **금지**
- **cwd**: worktree — `progress.md` Working directory와 일치
- **`--draft` 없음** — Ready for review
- **Co-Authored-By 금지**

## 사전 조사 (병렬)

```bash
git status
git branch -vv
git log develop..HEAD --oneline
git diff develop...HEAD
```

## 제목

```text
[SOU-XXX] 한국어 요약
```

- `[SOU-XXX]` ← 브랜치 `feat/SOU-XXX/slug` (70자 이하)

## 본문

- 템플릿: `.github/pull_request_template.md`
- 채우기: `docs/harness/templates/pr-body.md`
- **변경 요약**: `Plan: docs/plans/{feature-slug}/plan.md` + bullet 2~4개 (`develop...HEAD` **전체**)
- **변경 내용** · **스크린샷** · **기타**: 템플릿 섹션 유지

## 생성

```bash
git push -u origin HEAD   # upstream 없을 때만 (push는 G4·사용자 맥락)
gh pr create --base develop --title "[SOU-XXX] …" --body "$(cat <<'EOF'
…
EOF
)"
```

- `--draft` **사용하지 않음**
- PR URL 반환

## 선행

- 리뷰 단위 커밋 권장 → `souzip-commit`
- verify 생략 시 기타에 1줄 경고 가능

## 라우팅

- 커밋만 → `souzip-commit`
