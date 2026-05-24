# bugbot-review-rules — 단일 `.cursor/BUGBOT.md` 리서치 및 구현 계획

> **민감 정보 금지**: API 키·토큰·실계정·미공개 사업/수치·장문 내부 전략은 이 파일에 쓰지 않는다.  
> 초안·가설·장문 메모 → `draft-*` / `notes-*` (gitignore) 또는 `docs/harness/scratch/`.

## intake 요약 (2026-05)

| 항목 | 결정 |
|------|------|
| 초점 | 로직·보안·아키텍처·Swift 품질·PR/하네스 정합 **전부** |
| 톤 | **균형** — merge 전 고칠 만한 것만 |
| 코멘트 | **한국어** |
| 보관 | **저장소 단일 파일** `.cursor/BUGBOT.md` (대시보드 Manual Rules 일일 입력 ❌) |
| 스킵 | 생성물·docs 스타일 nit·Config 스타일·SwiftLint nit·빌드/테스트 (A~E) |
| CodeRabbit | 본 작업 범위 **외** — 병행 유지 가능, 규칙 중복 최소화 |

---

## 목표

Souzip PR용 **Bugbot 리뷰 규칙**을 CodeRabbit `.coderabbit.yaml`처럼 **버전 관리되는 한 파일**로 둔다. Cursor 대시보드 Manual Rules 없이도 동일 정책이 적용되게 한다.

---

## 비목표

- `.coderabbit.yaml` 수정·제거
- 레이어별 `Projects/*/.cursor/BUGBOT.md` 분리 (이번엔 **루트 1파일만**)
- Bugbot Autofix ON
- 대시보드 Learned Rules 끄기 (ON 유지 가능)
- iOS 앱 코드(`Projects/**`) 기능 변경
- `docs/harness/` 정본 대량 수정 (선택: README 한 줄 링크만)

---

## 파악한 구조

| 항목 | 내용 |
|------|------|
| Bugbot 규칙 (공식) | [Bugbot docs](https://cursor.com/docs/bugbot) — `.cursor/BUGBOT.md`, 변경 파일에서 상위로 merge |
| 적용 조건 | **기본 브랜치(`develop`)에 머지된 뒤** PR 리뷰에 반영 (PR에만 있으면 미적용 가능) |
| 우선순위 | Team Rules → 대시보드(수동·Learned) → **BUGBOT.md** → User Rules |
| 정본과 정합 | [`AGENTS.md`](../../../AGENTS.md), [`docs/harness/constitution.md`](../../harness/constitution.md), [`docs/harness/context/`](../../harness/context/) |
| 검증 PR | [#70](https://github.com/souzip/souzip-iOS/pull/70) — `bugbot run` (Run Once ON 시 수동) |
| 저장소 | `souzip/souzip-iOS` |

**참고:** Bugbot은 링크된 다른 md를 **항상** 읽지 않을 수 있음. 핵심 규칙은 `BUGBOT.md` 본문에 둔다. (선택) 상대 링크로 constitution 참조.

---

## 변경 계획

### `.cursor/BUGBOT.md` (신규)

- **이유:** intake 확정 — 대시보드 일일 입력 대신 yaml 수준의 단일 SSOT
- **Before:** 없음
- **After:** [부록 A — `.cursor/BUGBOT.md` 초안](#부록-a-cursorbugbotmd-초안) 전문 (구현 시 그대로 생성)

---

### `docs/harness/README.md` (선택)

- **이유:** 다음 세션이 Bugbot 규칙 위치를 찾게
- **Before:** Bugbot 언급 없음
- **After:** 한 줄 — Bugbot 규칙: `.cursor/BUGBOT.md` · plan: `docs/plans/bugbot-review-rules/plan.md`

(구현 시 harness PR과 같이 넣을지, 별도 docs 커밋할지 사용자 판단)

---

### Cursor Bugbot 대시보드 (수동 작업, 코드 아님)

- **이유:** 파일과 Manual Rules 이중 적용 시 충돌·중복 코멘트
- **Before:** (없거나) intake 시 제안했던 7개 Manual Rules
- **After:**
  - **Manual / Repository Rules:** 비우거나 1줄 — `리뷰 규칙은 저장소 .cursor/BUGBOT.md 따름`
  - **Automatically Learn Rules:** ON 유지 (선택)
  - **Run Once Per PR:** ON · **Autofix:** OFF (기존 합의)

---

## 구현 순서 (「구현해」 후)

1. `.cursor/BUGBOT.md` 생성 (부록 A)
2. `develop`에 머지될 브랜치에 포함 (예: `chore/SOU-637/...` 또는 `docs/bugbot-rules` 브랜치)
3. 머지 후 PR에서 `bugbot run` → 한국어·아키텍처·스킵 경로 동작 확인
4. (선택) `docs/harness/README.md` 한 줄
5. `progress.md` Session Record · 본 plan 완료 기준 체크

---

## 완료 기준

- [x] `.cursor/BUGBOT.md`가 저장소 루트 `.cursor/`에 존재하고 부록 A와 실질 동일
- [ ] `develop`(또는 Bugbot이 보는 기본 브랜치)에 해당 파일이 포함됨
- [ ] 대시보드 Manual Rules가 비어 있거나 “BUGBOT.md 따름”만 있음 (중복 7규칙 없음)
- [ ] 검증 PR 1건에서 `bugbot run` 실행 · **한국어** 인라인 코멘트 ≥1 또는 “이슈 없음” 요약
- [ ] (증거) PR 링크 + Bugbot check(`Cursor Bugbot`) 스크린샷 또는 `gh pr checks` 한 줄을 progress / 본 plan 하단에 기록
- [ ] `git diff Projects/` 없음 (문서·`.cursor`만 변경)

---

## 리스크·완화

| 리스크 | 완화 |
|--------|------|
| PR만 있고 develop에 없으면 규칙 미적용 | harness/bugbot PR을 develop에 먼저 머지 후 #70에서 `bugbot run` |
| CodeRabbit과 중복 코멘트 | Bugbot=로직·Critical 아키텍처, CR=incremental·Lint (톤 균형) |
| 파일 길이 한도 | 1파일 유지, nit은 스킵 섹션으로 억제 |

---

## 참고

- intake: 본 채팅 (2026-05)
- Bugbot 트리거: `bugbot run` / `cursor review`
- 병행: `.coderabbit.yaml` 유지

---

## 부록 A — `.cursor/BUGBOT.md` 초안

> 구현 시 아래를 **그대로** `.cursor/BUGBOT.md`로 저장한다.

```markdown
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
```

---

## 승인 후

사용자 **「구현해」** → `.cursor/BUGBOT.md` 생성 및 (선택) harness README 한 줄.  
커밋·PR은 **G4** — 사용자 「커밋해」「PR」 지시 시만.
