# 완료 플랜 archive

활성 `docs/plans/{feature}/`를 짧게 유지하기 위한 **이관** 폴더입니다.  
archive도 **git 추적**합니다 (히스토리·PR 근거).

## 이관 절차

1. 기능이 `develop`에 머지되었거나 더 이상 active 작업이 없을 때
2. 폴더 이동:

```bash
# 예: wishlist-ui 완료 (2026)
mkdir -p docs/plans/archive/2026
git mv docs/plans/wishlist-ui docs/plans/archive/2026/wishlist-ui
```

3. `docs/harness/progress.md`에 한 줄 기록 (선택)
4. 커밋 메시지 예: `docs: wishlist-ui 플랜 archive 이관`

## 규칙

- **이동만** — `plan.md` 내용 대량 수정은 archive 시 하지 않음
- 연도별 `archive/{year}/` — 연도 넘기면 새 year 폴더
- active 작업 중인 feature는 archive **하지 않음**

## ignore 대상 아님

`archive/` 안의 `plan.md`는 추적 유지. 초안(`draft-*`)은 이관 전에 삭제하거나 로컬에만 두기.
