---
name: souzip-pr
description: >
  Souzip PR(G4). 트리거: PR 만들어줘, PR 생성, PR 올려줘.
  PR 생성 전 souzip-verify 체크 필수. base develop, [SOU-XXX], --draft 없음.
---

# Souzip — PR

정본: `docs/plans/workflow-skills-jira-git/pr-review-flow.md` · G4

## 게이트

- **G4**: 「PR 만들어줘」 등 **명시** 없으면 `gh pr` / push **금지**
- **G3 (PR 내장)**: `gh pr` / push **전** 아래 **1. 검증** 통과. **Critical** 있으면 PR 중단
- **cwd**: worktree — `progress.md` Working directory와 일치
- **`--draft` 없음** — Ready for review
- **Co-Authored-By 금지**

## 흐름 (순서 고정)

1. **검증** — `souzip-verify` 체크리스트 (`00-triggers.md` §5) · `develop...HEAD` 기준
2. **사전 조사** — 아래 git (검증과 병렬 가능)
3. **리뷰 노트** — 심각도별 이슈 · **Go / No-Go** (Critical 0개여야 Go)
4. **제목·본문** — Go일 때만 초안
5. **생성** — push(필요 시) → `gh pr create`

**No-Go**: implement 재개 또는 수정 후 다시 「PR 만들어줘」. `gh pr` **금지**.

**예외**: 사용자가 같은 맥락에서 **「verify 생략하고 PR」** 등 명시 시 → PR **기타**에 1줄 경고 후 4~5 진행 (Quick·docs-only 등).

## 1. 검증 (`souzip-verify` 본문)

- [ ] 변경이 `plan.md` 범위 안 (`docs/plans/{feature}/plan.md` — 브랜치·diff로 추론)
- [ ] Presentation → Data 직접 import 없음
- [ ] Domain 외부 의존 없음 · `!` · Combine 없음
- [ ] plan에 테스트 있으면 **실행** (실패 → No-Go)
- [ ] Factory·새 피처 시 5단계 점검
- [ ] (권장) `progress.md` / `feature-tracker.json`에 검증 요약 1~2줄

검증만 요청했을 때와 동일 체크. 코드 수정은 verify 규칙대로 plan 범위 버그픽스만.

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
- 이미 「리뷰해」로 verify 했어도 **PR 시 1. 검증 다시** (diff·커밋이 바뀌었을 수 있음)

## 라우팅

- 검증만 → `souzip-verify`

- 커밋만 → `souzip-commit`
