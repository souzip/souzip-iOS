# Souzip AI Harness

도구 중립 협업 규약. 진입: 루트 [`AGENTS.md`](../../AGENTS.md).

LHE 최소 팩(A~E) + Souzip 5모드·게이트를 [`docs/harness/`](.)에 일원화했다.

## 4층 모델

| 층 | 경로 | 한 줄 | 예 |
|----|------|-------|-----|
| **constitution** | `docs/harness/constitution.md` | 바뀌지 않는 규칙·금지·Git | `!` 금지 |
| **context** | `docs/harness/context/` | 프로젝트·아키텍처 | Tuist, 레이어 |
| **workflow** | `docs/harness/workflows/` | 모드·절차 | `00-triggers.md`, `01-session-lifecycle.md`, `02-harness-improvement.md` |
| **artifact** | `docs/plans/{feature}/` | 작업별 산출물 | `plan.md`, `feature-tracker.json` |

하네스 **제작** 메타: `docs/plans/agent-harness-rebuild/`.

## Context (프로젝트 구조)

AI가 코드 전체를 훑기 전에 읽는 정본: [`context/README.md`](context/README.md)

| 문서 | 용도 |
|------|------|
| [`context/architecture.md`](context/architecture.md) | **전체** 레이어·부트스트랩·Coordinator 트리 |
| [`context/layers.md`](context/layers.md) | 모듈·import·Factory 경계 |
| [`context/presentation.md`](context/presentation.md) | MVVM-C·BaseView·Scene |
| [`context/domain-and-data.md`](context/domain-and-data.md) | UseCase·Repository·DTO |
| [`context/feature-playbook.md`](context/feature-playbook.md) | 새 기능 ①~⑤ 단계 |

## LHE 대응 (A~E)

| 옵션 | 파일 |
|------|------|
| A progress | [`progress.md`](progress.md) |
| B feature + evidence | [`templates/feature-tracker.json`](templates/feature-tracker.json) |
| C DoD·루틴 | [`AGENTS.md`](../../AGENTS.md) · [`workflows/01-session-lifecycle.md`](workflows/01-session-lifecycle.md) |
| D preflight | [`scripts/preflight.sh`](scripts/preflight.sh) |
| E 합성 | 위 + [`workflows/00-triggers.md`](workflows/00-triggers.md) 5모드 |

## 로드 정책

| 항상 (세션 시작) | 필요 시 |
|------------------|---------|
| `AGENTS.md` | `constitution.md` |
| `.cursor/rules/00-souzip-harness.mdc` | `context/*.md` |
| [`progress.md`](progress.md) | `workflows/{단계}.md` |
| 스킬 → `souzip-*` | `docs/plans/{feature}/plan.md` |

implement 전: [`scripts/preflight.sh`](scripts/preflight.sh) (기준선, D).

## `docs/plans/` vs `scratch/` vs 초안

| | `plan.md` | `draft-*` / `notes-*` | `scratch/` |
|---|-----------|------------------------|------------|
| 용도 | 승인·DoD·구현 근거 | 초안·민감·장문 메모 | 당일 임시·**개발 인사이트 백업** 등 |
| git | **추적** | **ignore** | **ignore** |

개발 메모·인사이트 **로컬 백업** (gitignore): `scratch/backlog-dev-insights-log.md`, `scratch/xcode-tuist-structure.md` — friction-log 2026-05-24 행 참고.

가이드: [`../plans/README.md`](../plans/README.md) · [`gitignore-policy.md`](gitignore-policy.md)

## 디렉터리

```text
docs/
├── README.md
├── harness/              # 이 폴더
│   ├── progress.md
│   ├── friction-log.md   # 하네스·AI 마찰 (이벤트 기반)
│   ├── constitution.md
│   ├── context/
│   ├── workflows/        # 00·01·02
│   ├── scripts/preflight.sh
│   ├── templates/
│   └── scratch/          # gitignore
└── plans/{feature}/
```

[`migration-map.md`](migration-map.md) · [`gitignore-policy.md`](gitignore-policy.md) · [`jira-mcp-setup.md`](jira-mcp-setup.md)

## 하네스 개선 (이벤트 기반)

| 문서 | 용도 |
|------|------|
| [`friction-log.md`](friction-log.md) | 「마찰 기록해」「왜 그렇게 했어」→ **하네스·AI 협업** 마찰 한 행 |
| [`workflows/02-harness-improvement.md`](workflows/02-harness-improvement.md) | 「이거 토대로 개선하자」→ plan → 구현 |

**plan·PRD HTML 미리보기** (로컬·git 제외): [`../plans/README.md`](../plans/README.md) · `docs/plans/{feature}/*.html`
