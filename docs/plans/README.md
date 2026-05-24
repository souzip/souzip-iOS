# 기능 플랜 (`docs/plans/`)

승인·구현·검증의 **정본**은 Git에 남깁니다. 초안·민감 메모는 로컬만.

## 구조

```text
docs/plans/
├── README.md                 ← 이 파일
├── {feature}/
│   ├── plan.md               ← 추적 (필수 정본)
│   ├── feature-tracker.json  ← 큰 기능만 (선택)
│   ├── draft-*.md            ← gitignore (초안)
│   ├── notes-*.md            ← gitignore (민감·가설)
│   ├── local-*.md            ← gitignore (개인 메모)
│   └── *.html                ← gitignore (plan·PRD 브라우저 미리보기)
└── archive/
    └── {year}/{feature}/     ← 완료 후 이관 (추적)
```

## 작성 규칙

| 파일 | git | 용도 |
|------|-----|------|
| `plan.md` | ✅ | G1 승인·§완료 기준·Before/After |
| `draft-*` | ❌ | 장문 리서치·실험 |
| `notes-*` / `local-*` | ❌ | 민감·개인 메모 |
| `scratch/` (harness) | ❌ | 당일 임시 |
| `*.html` (이 폴더) | ❌ | plan·PRD **보기용** (정본은 md) |

## HTML 미리보기 (로컬)

「plan을 HTML로 만들어줘」「PRD 브라우저로 보고 싶어」처럼 요청하면, **해당 기능 폴더**에 생성한다.

| 예 | 경로 |
|----|------|
| 위시리스트 플랜 미리보기 | `docs/plans/wishlist-mypage-grid/preview.html` |
| PRD가 있을 때 | `docs/plans/{feature}/prd-preview.html` |

- **정본·승인·구현 근거**는 항상 `plan.md` / `prd.md` (git 추적).
- HTML은 `.gitignore`의 `docs/plans/**/*.html` — 커밋하지 않음, 로컬에서 `open` 으로 열면 됨.
- 하네스 공통 HTML 폴더(`docs/harness/reference/`)는 **사용하지 않음**.

템플릿: [`../harness/templates/plan-template.md`](../harness/templates/plan-template.md)  
정책: [`../harness/gitignore-policy.md`](../harness/gitignore-policy.md)

## 완료 후

머지·기능 종료 시 → [`archive/README.md`](archive/README.md).

## 하네스 제작 기록

`agent-harness-rebuild/` — 운영 정본 아님, ADR·비전 보관용.
