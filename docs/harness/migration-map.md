# Harness 이관·정리 기록

> 루트 `harness/` → `docs/harness/` (2026-05). **정본은 `docs/harness/`만.**

## 완료

| 제거·대체 | 정본 |
|-----------|------|
| `docs/claude/architecture.md` | `context/architecture.md` + `presentation.md` + `domain-and-data.md` |
| `docs/claude/module-layer-constitution.md` | `context/layers.md` |
| `docs/plans/.../triggers.md` (미러) | `workflow/gates.md` + `workflow/operating-sequence.md` |
| `harness/reference/*.html` (하네스 HTML) | **제거** — 구조는 `README.md`·`workflow/`·`context/` md |
| 루트 `harness/README.md` | `docs/harness/README.md` |

`docs/claude/` — 본문 삭제, [`README.md`](../claude/README.md) 리다이렉트만 유지.

## H6 예정 (미삭제)

| 대상 | 비고 |
|------|------|
| `CLAUDE.md` | 운영 정본 아님. 필요한 내용은 `AGENTS.md` + `docs/harness/`로 흡수 |
| `.claude/skills/*` | `souzip-*` 스킬로 대체 |

`docs/plans/agent-harness-rebuild/` — 하네스 **제작** 산출물. 운영 정본 아님, 보관.
