# Constitution — 비협상 규칙

> workflow·context보다 우선. H4에서 `CLAUDE.md`와 병합·정리.

## DO NOT

- `force_unwrapping` (`!`), `implicitly_unwrapped_optional`
- Storyboard / XIB — UI는 SnapKit 코드만
- Domain에 외부 의존성
- Presentation → Data 직접 참조
- `Config/*.xcconfig` 커밋 (시크릿)
- `tuist generate` 산출물 커밋 (`*.xcodeproj`, `*.xcworkspace`, `Derived/`)
- **Combine** — RxSwift만

## Git

**커밋** (한 줄, 한국어, body·Co-Authored-By 없음):

```text
<type>: <한국어 설명>
```

| type | 용도 |
|------|------|
| feat | 기능 |
| fix | 버그 |
| refactor | 구조 |
| style | 포맷 |
| docs | 문서 |
| test | 테스트 |
| chore | 기타 |

**브랜치**: `<type>/<JIRA-ID>/<설명>` · PR base: `develop`

## AI 협업 (constitution급)

- **G1**: plan + 사용자 승인 + 「구현해」/「구현 시작해」 **모두** 전 코드 변경 금지 ([`workflows/00-triggers.md`](workflows/00-triggers.md))
- **G3/G4**: verify·ship 게이트 — [`workflows/00-triggers.md`](workflows/00-triggers.md)
- **G4**: 명시 없이 commit / push / PR 금지
- 커밋·PR 주도권: 사용자 ([`../plans/agent-harness-rebuild/vision.md`](../plans/agent-harness-rebuild/vision.md))
- **기준선**: implement 전 `docs/harness/scripts/preflight.sh` 실패 시 새 기능 중단

## 컨벤션 (요약 — 상세 H4)

- 한국어 커밋·주석
- SnapKit: `makeConstraints { make in` (`$0` 금지)
- `setHierarchy`: `[views].forEach(addSubview)`
- BaseViewModel 4타입 · Mapper로 DTO→Domain · Factory DI
- `import` testable 맨 아래

전체: [`CLAUDE.md`](../../CLAUDE.md) (레거시 요약) · 구조 정본: [`context/README.md`](context/README.md)
