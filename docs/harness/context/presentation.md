# Presentation 레이어 패턴

> 상위 구조: [`architecture.md`](architecture.md) · import 규칙: [`layers.md`](layers.md)

## 역할

- 사용자 입력 → **Action**, 화면 상태 → **State**, 일회성 UI → **Event**, 화면 전환 의도 → **Route**.
- 비즈니스 실행은 **UseCase**만 호출 (`import Domain`). Repository·DTO 접근 금지.

## MVVM-C 구성

```text
View (BaseView) ──action──▶ ViewModel ──route──▶ Coordinator
       ▲                        │
       └── state (Driver) ──────┘
              event → ViewController.handleEvent
```

| 타입 | Relay | 용도 |
|------|-------|------|
| **State** | `BehaviorRelay` | UI 단일 진실 |
| **Action** | `PublishRelay` | 탭·입력·lifecycle (`viewDidLoad` 등) |
| **Event** | `PublishRelay` | 로딩, 알럿, refresh 종료 |
| **Route** | `PublishRelay` | push/pop/modal 의도 |

### ViewModel API (`BaseViewModel`)

- `mutate { $0.... }` — 상태 변경
- `emit(.loading(true))` — Event
- `navigate(to: .detail(id:))` — Route
- `handleAction` 내부: `Task { await useCase.execute() }` (async/await)

타입 정의: 화면별 `*Intent.swift` (`DiscoveryAction`, `DiscoveryState`, `DiscoveryEvent` 등). Route는 동일 파일 또는 VM 옆.

### ViewController (`BaseViewController<VM, ContentView>`)

- `loadView` → `contentView`가 root.
- `contentView.action` → `viewModel.action` (자동).
- `viewModel.event` → `handleEvent` override.
- `bindState()` override → `StateObserver` / `asDriver()`로 View 갱신.

### View (`BaseView<Action>`)

override 순서 고정:

1. `setAttributes()` — DS 색·컴포넌트
2. `setHierarchy()` — `[a, b].forEach(addSubview)` (멀티라인 배열 + forEach)
3. `setConstraints()` — `snp.makeConstraints { make in ... }` (`$0` 단축 금지 — 가독성·팀 컨벤션)
4. `setBindings()` — `bind(...).to(.action)` / `ActionBinder`

**ActionBinder**: `throttle`, `debounce`, `map`, `compactMap`, `withLatestFrom` → terminal `.to(Action)` 또는 `.map { }`.

## Coordinator · RoutedScene

### RoutedScene

`PresentationFactory` 조립 결과:

```swift
RoutedScene(vc: vc, route: vm.route, disposeBag: vc.disposeBag)
```

- `bindRoute(scene)` — `vm.route` → `navigate(_:)` (throttle 300ms, `asSignal`).
- VM Route ≠ Coordinator Route → `bindRoute(_:mapper:)`.

### Coordinator API

- `addChild` / `addTemporaryChild` — 자식 생명주기
- `navigateToParent` — 탭·루트 위임 (`TabRoute`, `RootRoute`)
- 화면 전환은 Coordinator만 — VC에서 `push` 직접 호출 금지

## Scene 폴더 규칙

```text
Projects/Presentation/Sources/
  Scene/{도메인}/{화면명}/
    Base/     → *Intent, *ViewModel, *View, *ViewController
    SubView/  → 셀·섹션 UIView
    Model/    → UI 전용 모델
  Coordinator/{도메인}/  → *Coordinator, *Route
  Util/Base|Binding|Factory|Extension/
```

- 기존 경로 `Scene/Souvernir/` (오타) — 새 파일은 **기존 경로 유지**, 리네임은 별도 작업.
- 복잡 탭: 자식 VM (`MyPageCollectionTabViewModel`) + 부모 VM이 Route·공통 상태.

## DesignSystem

- `DS*` 컴포넌트 (`DSNavigationBar`, `DSFAButton`), `.dsBackground` 등.
- 공통 UI는 DesignSystem 우선; UIKit 직접 조합은 레이아웃·서브뷰 한정.

## Presentation Store (Factory lazy)

| Store | 용도 |
|-------|------|
| `AuthSessionStore` | 로그인 상태 → 게스트 UI |
| `UserSouvenirInvalidationStore` | 기념품 CRUD 후 목록 무효화 |

Domain 로직 대체 아님 — ViewModel에 주입만.

## Rx 규칙 (Presentation)

- RxSwift / RxRelay / RxCocoa만.
- State → VC에서 `Driver`; Action/Event/Route → Relay.
- Coordinator: `route.asSignal(onErrorSignalWith: .empty())`.

## 코드 앵커

| 개념 | 경로 |
|------|------|
| BaseViewModel | `Presentation/.../Base/ViewModel/BaseViewModel.swift` |
| BaseViewController | `Presentation/.../Base/ViewController/BaseViewController.swift` |
| BaseView | `Presentation/.../Base/View/BaseView.swift` |
| ActionBinder | `Presentation/.../Binding/ActionBinder.swift` |
| Coordinator | `Presentation/.../Base/Coordinator/BaseCoordinator.swift` |
| Factory 예 | `Presentation/.../Factory/PresentationFactory+Souvenir.swift` |
| Coordinator 예 | `Presentation/.../Coordinator/Auth/AuthCoordinator.swift` |
