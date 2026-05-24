# 새 기능 플레이북

> API·화면·도메인 로직을 **처음부터** 넣을 때의 순서. 플랜(`docs/plans/{feature}/plan.md`) §완료 기준과 함께 쓴다.

## 시작 전

1. [`layers.md`](layers.md) — import·Factory 경계 확인.
2. [`presentation.md`](presentation.md) / [`domain-and-data.md`](domain-and-data.md) — 해당 레이어 패턴.
3. implement 게이트: `docs/harness/scripts/preflight.sh` 통과 (G0).

## 흐름 요약

```text
① Domain (모델·Repository·UseCase·Error)
② Data (DTO·Endpoint·DataSource·Repository 구현·Mapper)
③ Domain/Data Factory 연결
④ Presentation (Intent·VM·View·VC·Route·Coordinator)
⑤ PresentationFactory + (필요 시) Coordinator 분기
⑥ Tuist 의존성 (SPM 추가 시만)
⑦ verify — 레이어·plan·증거
```

---

## ① Domain

경로: `Projects/Domain/Sources/{Feature}/`

| 산출물 | 규칙 |
|--------|------|
| `Model/` | API 무관 순수 타입. UI 전용 타입은 Presentation에 둠. |
| `Repository/{Feature}Repository.swift` | `protocol`, `async` 메서드. |
| `UseCase/{Verb}{Noun}UseCase.swift` | `protocol` + `Default*`, Repository만 의존. |
| `Error/{Feature}Error.swift` | Domain 에러 enum. |

체크:

- [ ] `import`가 Foundation 수준만 (Rx, Networking, UIKit 없음).
- [ ] UseCase `execute` 시그니처가 UI 요구와 맞음 (파라미터·반환 Domain 타입).

**Factory (Domain)**

- `Domain/Sources/Util/Factory/Domain{Feature}Factory.swift` — `make*UseCase()`, `make*Repository()` (Repository는 `factory.make*()` 위임).
- `DomainFactory.swift` 프로토콜에 `Domain{Feature}Factory` 추가.
- `DomainFactory+{Feature}.swift` (`DefaultDomainFactory` extension).

**Data 쪽 프로토콜**

- Repository 구현 노출: `Data/Sources/Util/Factory/DataFactory.swift`에 `make{Feature}Repository()` 추가 (프로토콜은 `Domain/Sources/Util/Factory/DataFactory.swift`).

---

## ② Data

경로: `Projects/Data/Sources/{Feature}/`

| 순서 | 산출물 | 규칙 |
|------|--------|------|
| 1 | `Endpoint/{Feature}Endpoint.swift` | `enum` + `APIEndpoint` |
| 2 | `DTO/` | Response/Request Codable. **Domain 타입 없음**. |
| 3 | `DTO/{Feature}DTOMapper.swift` | `static func toDomain(_ dto:)` |
| 4 | `DataSource/*RemoteDataSource.swift` | `NetworkClient.request` |
| 5 | `Repository/Default{Feature}Repository.swift` | Domain 프로토콜 준수, Mapper 사용, `NetworkError` → Domain Error |

Remote만 있으면 RemoteDataSource만; 로컬 캐시·JSON이면 LocalDataSource 추가 (Country·Onboarding 참고).

**Factory (Data)**

- `DefaultDataFactory`에 `private lazy var cached{Feature}Repository` + `make{Feature}Repository()`.
- Authed API면 `networkFactory.makeAuthedClient(cachedTokenRefresher)` 패턴 유지.

체크:

- [ ] DTO에 `toDomain()` 인스턴스 메서드로 직접 구현하지 않음.
- [ ] `import Domain`은 Repository·Mapper에서만 (DTO 파일은 Domain import 금지).

---

## ③ Factory 연결 (App)

`AppFactory`는 보통 **수정 불필요** (이미 Data→Domain 체인 존재).

새 Repository가 `DataFactory` 프로토콜에 추가되었는지, `DefaultDomainFactory` extension이 UseCase를 조립하는지만 확인.

---

## ④ Presentation

경로: `Projects/Presentation/Sources/Scene/{Feature}/…`

### 최소 파일 세트 (한 화면)

| 파일 | 내용 |
|------|------|
| `{Screen}Intent.swift` | `Action`, `State`, `Event` (+ `Route` 또는 별도 Route enum) |
| `{Screen}ViewModel.swift` | `BaseViewModel` 서브클래스, UseCase 주입, `handleAction`, `Task` |
| `{Screen}View.swift` | `BaseView<Action>`, SnapKit, `setBindings` |
| `{Screen}ViewController.swift` | `BaseViewController`, `bindState`, `handleEvent` |

### Coordinator·Route

- 탭/루트에 붙는 화면: `Coordinator/{Feature}/{Feature}Route.swift`에 case 추가.
- `*Coordinator.navigate`에 분기 + `factory.make*Scene()`.
- 하위 플로우만: 기존 `SouvenirCoordinator`처럼 **embedded route** (`MyPageRoute.souvenirRoute`).

### Factory (Presentation)

- `Presentation{Feature}Factory.swift` — `make{Screen}Scene() -> RoutedScene<{Route}>`.
- `PresentationFactory+{Feature}.swift` — VM에 `domainFactory.make*UseCase()` 주입, View+VC 조립.

```swift
// 패턴 (요약)
let vm = FooViewModel(useCase: domainFactory.makeFooUseCase(), ...)
let view = FooView()
let vc = FooViewController(viewModel: vm, contentView: view)
return .init(vc: vc, route: vm.route, disposeBag: vc.disposeBag)
```

체크:

- [ ] `import Data` 없음.
- [ ] 네비게이션은 `navigate(to:)` — VC에서 `push` 직접 호출 금지 (Coordinator가 처리).
- [ ] `setHierarchy`: `[a, b].forEach(addSubview)` 형태.

---

## ⑤ Tuist / SPM (해당 시만)

- 새 외부 라이브러리: `Tuist/Package.swift` + `ExternalLibrary` + `ModuleDependencies` 대상 모듈.
- 모듈 간 의존은 [`layers.md`](layers.md) 표 준수.

---

## ⑥ 플랜·검증 연계

`plan.md`에 넣을 **기능별** 완료 기준 예:

- [ ] Domain/Data/Presentation Factory 메서드 존재
- [ ] `preflight.sh` 성공
- [ ] (동작) … 사용자 가시 동작 한 줄
- [ ] Presentation → Data import 없음 (grep 또는 리뷰)
- [ ] (증거) Xcode scheme 빌드 또는 스크린샷

verify 모드: [`../workflows/00-triggers.md`](../workflows/00-triggers.md) §5 + `feature-tracker.json` evidence.

---

## 기능 유형별 분기

| 유형 | Domain/Data | Presentation | 비고 |
|------|-------------|--------------|------|
| **API만** | ①② 필수 | 없음 | UseCase 단위 테스트는 plan에 있을 때 |
| **화면만** (기존 API) | Factory·UseCase 연결만 | ④⑤ | plan에 기존 UseCase 명시 |
| **탭·루트 화면** | ①② | ④⑤ + Tab/Root Coordinator | `TabRoute` 등 |
| **모달·시트** | ①② | `addTemporaryChild` Coordinator | LoginBottomSheet 참고 |
| **OAuth·딥링크** | Data Auth | App `SceneDelegate` | Presentation 경유 없음 |

---

## 네이밍·파일 체크리스트 (한 기능 끝낼 때)

**Domain**

- [ ] `Projects/Domain/Sources/{Feature}/Model/…`
- [ ] `…/Repository/{Feature}Repository.swift`
- [ ] `…/UseCase/Default*UseCase.swift`
- [ ] `…/Error/{Feature}Error.swift`
- [ ] `Util/Factory/Domain{Feature}Factory.swift` + `DomainFactory+{Feature}.swift`

**Data**

- [ ] `…/Endpoint/`, `DTO/`, `DataSource/`, `Repository/Default*.swift`
- [ ] `DataFactory` + `DefaultDataFactory` lazy repository

**Presentation**

- [ ] `Scene/…/Base/*Intent`, `*ViewModel`, `*View`, `*ViewController`
- [ ] `Coordinator/*Route`, navigate 분기
- [ ] `PresentationFactory+{Feature}.swift`

---

## 참고 구현 (코드에서 복사할 때)

| 패턴 | 참고 경로 |
|------|-----------|
| 얇은 UseCase + Repository | `Domain/.../Wishlist/` |
| Endpoint + Remote + Mapper | `Data/.../Wishlist/` |
| Diffable Collection UI | `Scene/Discovery/Discovery/Base/DiscoveryView.swift` |
| Factory Scene 조립 | `Util/Factory/PresentationFactory+Souvenir.swift` |
| Coordinator + bindRoute | `Coordinator/Auth/AuthCoordinator.swift` |
| 탭 자식 Coordinator | `Coordinator/Tabbar/TabBarCoordinator.swift` |

---

## 하지 말 것 (플레이북)

- plan 승인·「구현해」 전 코드 (G1).
- Presentation에 Repository·DTO 노출.
- Mapper 없이 DTO를 Domain으로 직접 변환.
- Storyboard, `!`, Combine.
- Factory 없이 `ViewModel()`을 VC에서 직접 생성 (테스트 더블 제외).
