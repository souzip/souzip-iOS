# Gitignore 정책 (하네스·plans)

## 현재 (2026-05 — 추천 조합)

### Git 추적 (SoR)

| 경로 | 용도 |
|------|------|
| `docs/plans/{feature}/plan.md` | 승인·구현·DoD **정본** |
| `docs/plans/{feature}/feature-tracker.json` | 큰 기능만 (선택) |
| `docs/plans/{feature}/milestones.md`, `prd.md` | 있을 때만 |
| `docs/plans/archive/{year}/{feature}/` | **완료** 기능 이관 (추적 유지) |
| `docs/harness/` 본문 | progress, workflows, context 등 |

### Git 제외

| 패턴 | 용도 |
|------|------|
| `docs/harness/scratch/**` | 당일 임시 메모 |
| `docs/plans/**/draft-*` | 초안·장문 리서치 (로컬) |
| `docs/plans/**/local-*` | 개인 메모 |
| `docs/plans/**/notes-*` | 민감·사업 가설 등 |
| `docs/plans/**/local-notes.md` | 고정 파일명 메모 |
| `docs/plans/**/*.html` | UI 가이드 HTML (`harness/reference/` 사용) |
| `.cursor/settings.json` | Cursor 로컬 플러그인 설정 |
| `.cursor/mcp.json` | MCP 중복 설정 (플러그인 우선) |

`.gitignore`에 `docs/plans/` **전체** ignore는 하지 않는다.

## plan.md에 넣어도 되는 것 / 빼야 하는 것

**넣어도 됨**: 범위, 비목표, Before/After(코드 발췌), 완료 기준, 공개 가능한 API·화면 동작, Jira ID.

**넣지 말 것** (→ `scratch/` · `draft-*` · `notes-*` · Notion 등):

- API 키·토큰·`xcconfig` 값
- 실제 유저/QA 계정·개인 연락처
- 미공개 사업 수치·내부 전용 URL 전체
- “왜 이 사업이 돈이 되는지” 등 **민감 전략** 장문

템플릿: [`templates/plan-template.md`](templates/plan-template.md)

## 폴더 규칙

- 기능당 **`docs/plans/{feature}/` 하나**, 마일스톤은 `plan.md` §로 통합 (폴더 `*-m2` 남발 지양).
- 완료·머지 후: [`../plans/archive/README.md`](../plans/archive/README.md) 참고해 `archive/`로 이동.
- HTML 가이드·장문 UI 스펙: `docs/plans/` 대신 `docs/harness/reference/` 또는 plan 요약만.

## 판단 기준 (추가 ignore 전)

1. 다음 세션·다른 도구가 **파일 없이** 이어갈 수 있는가?
2. PR/리뷰에 **근거**로 남겨야 하는가?

둘 중 하나라도 “아니오”면 ignore 하지 않는다. 적용 시 **이 파일에 날짜·패턴·이유** 기록.

## 변경 이력

| 날짜 | 변경 |
|------|------|
| 2026-05 | plans 전체 추적 (SoR) |
| 2026-05 | 추천 조합: `draft-*` / `local-*` / `notes-*` ignore, archive 가이드 |
