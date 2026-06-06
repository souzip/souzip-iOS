# 정책 (Git · 민감정보)

에이전트·문서 말투: [`communication.md`](communication.md)

## Git

| | 경로 |
|---|------|
| ✅ 추적 | `docs/harness/**`, `docs/goals/README.md` |
| ❌ ignore | `docs/goals/*` (goal·plan·archive) |

## 작업 문서

- **메인 클론** `docs/goals/{feature-slug}/` 만
- **worktree** = 코드 · 브랜치 · PR

## 민감정보

plan·interview에 API 키·토큰·실계정 금지. 장문 메모는 필요할 때 별도 메모 파일에 둡니다.

## PR

plan은 Git에 없음 → PR 본문에 **요약 5줄** (`docs/harness/templates/ship/pr-body.md`).
