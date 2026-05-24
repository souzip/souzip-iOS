# Souzip — Bugbot 리뷰 규칙

> 정본: [AGENTS.md](../AGENTS.md) · [docs/harness/constitution.md](../docs/harness/constitution.md) · [docs/harness/context/](../docs/harness/context/)

## 언어·톤

- 모든 리뷰 코멘트는 **한국어**로 작성한다. 코드 식별자·API 이름은 원문 유지.
- **균형:** merge 전에 고칠 가치가 있는 이슈만 지적한다. 불확실하면 가능성으로 표시하고 과장하지 않는다.

## 리뷰하지 않음 (스킵)

- 포맷·세미콜론·네이밍 nit → SwiftLint / 로컬 preflight
- 빌드·테스트 통과 여부 → CI / `docs/harness/scripts/preflight.sh`
- 다음 경로의 **로직·스타일** 리뷰 (유출·보안만 예외):
  - `**/Derived/**`, `**/*.xcodeproj/**`, `**/*.xcworkspace/**`
  - `**/Tuist/.build/**`, `**/*.xcassets/**`, `**/*.lproj/**`
  - `docs/harness/scratch/**`
- `docs/**`, `.cursor/skills/**`: 문장·마크다운 스타일 nit 금지. 링크·게이트·`00-triggers.md` 모순만.

## 프로젝트 공통

- Souzip iOS · Tuist · Swift 5.9 · iOS 16+ · **RxSwift only** (Combine 금지)
- UI: SnapKit 코드만 — Storyboard / XIB 금지
- **Critical:** `force unwrap (!)`, IUO, Combine, Storyboard/XIB
- SnapKit: `makeConstraints { make in }` (`$0` 단축 금지)
- DI: Factory 체인 (직접 init 난사 지적)

## 로직·Swift·Rx (Projects/**)

- nil/옵셔널, 잘못된 empty/error 처리
- Rx: 구독 dispose 누락, 중복 구독, 메인 스레드 UI, 완료 전 UI 갱신
- ViewModel: BaseViewModel 4타입 (State / Action / Event / Route) 이탈

## 아키텍처 (Critical)

| 레이어 | 규칙 |
|--------|------|
| **Domain** | 순수 비즈니스만. 외부 프레임워크·다른 모듈 import 금지. Repository는 프로토콜만. |
| **Presentation** | Domain만 의존. **Data / Networking 직접 import = Critical** |
| **Data** | Repository 구현·DTO·Endpoint. DTO→Domain은 **Mapper만** (DTO에 `toDomain()` 금지) |
| **App** | Factory 체인으로 DI |

## 보안

- `Config/**`가 PR에 있으면: API 키·토큰·시크릿·xcconfig 유출만 **Critical** (스타일 리뷰 금지)
- 민감정보 로깅·하드코딩 키

## Tuist/**

- `ModuleDependencies`가 [layers.md](../docs/harness/context/layers.md) 레이어 규칙과 모순되면 Critical
- 타겟·의존성 누락으로 빌드 실패 가능성 — 지적. 네이밍 nit 금지

## PR·하네스 (docs-only가 아닐 때)

- 기능 코드 PR 본문에 `docs/plans/{feature}/plan.md` 참조가 없으면 **Info** 수준으로만 안내
- `docs/**` 변경: `docs/harness/workflows/00-triggers.md`와 `.cursor/skills/souzip-*` 모순 검사

## 우선순위

1. Critical: 보안 유출, Presentation→Data, Domain 오염, Combine/force unwrap
2. 로직 버그·Rx 누수
3. 하네스·plan 링크 정합
