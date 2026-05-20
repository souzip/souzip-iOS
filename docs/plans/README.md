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
│   └── local-*.md            ← gitignore (개인 메모)
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

템플릿: [`../harness/templates/plan-template.md`](../harness/templates/plan-template.md)  
정책: [`../harness/gitignore-policy.md`](../harness/gitignore-policy.md)

## 완료 후

머지·기능 종료 시 → [`archive/README.md`](archive/README.md).

## 하네스 제작 기록

`agent-harness-rebuild/` — 운영 정본 아님, ADR·비전 보관용.
