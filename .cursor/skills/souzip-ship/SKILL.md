---
name: souzip-ship
description: >
  Souzip ship 라우터(G4). 커밋해 → souzip-commit, PR 만들어줘 → souzip-pr.
  하위 호환용. 직접 commit/gh pr 하지 말고 위 스킬 본문을 따른다.
---

# Souzip — ship (라우터)

정본: `docs/harness/workflows/00-triggers.md` · G4

## 게이트

- **G4**: 「커밋해」「PR 만들어줘」 등 **명시** 없으면 git commit / push / `gh pr` **금지**

## 라우팅

| 사용자 | 스킬 |
|--------|------|
| 커밋해, ~만 커밋해 | **`souzip-commit`** |
| PR 만들어줘, PR 생성, PR 올려줘 | **`souzip-pr`** |
| 작업 시작, worktree, 브랜치 만들어 | **`souzip-start`** |

해당 스킬 `SKILL.md` 본문을 **그대로** 따른다. 이 파일에 커밋·PR 절차를 중복하지 않는다.
