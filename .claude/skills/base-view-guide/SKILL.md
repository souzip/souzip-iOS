---
name: base-view-guide
description: >
  Use this skill when the user wants to create a new UIView subclass, asks how to write a View
  following Souzip's BaseView<Action> pattern, or asks about ActionBinder chain usage.
  Triggers on phrases like "새 View 만들어줘", "BaseView 써서 만들어줘", "ActionBinder 어떻게 써",
  "bind() 패턴", "새 화면 View 작성", or any request to create a UIView/BaseView subclass.
version: 1.0.0
---

# BaseView<Action> + ActionBinder 신규 작성 가이드

Souzip의 모든 View는 `BaseView<Action>`을 상속하고 `ActionBinder` 체인으로 이벤트를 바인딩한다.

---

## 1. 클래스 구조 템플릿

```swift
// 1) Action enum — 이 View가 발행할 수 있는 모든 이벤트
enum FooAction {
    case tapBack
    case selectItem(BarItem)
    case tapSubmit
}

// 2) View 클래스 — BaseView<FooAction> 상속
final class FooView: BaseView<FooAction> {

    // MARK: - Subviews
    private let naviBar = DSNavigationBar(title: "제목", style: .back)
    private let submitButton = DSButton()

    // MARK: - BaseView Overrides (반드시 클래스 본문에, extension 금지)
    override func setAttributes() {
        backgroundColor = .dsBackground
    }

    override func setHierarchy() {
        [naviBar, submitButton].forEach(addSubview)
    }

    override func setConstraints() {
        naviBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        // ...
    }

    override func setBindings() {
        // 모든 이벤트 바인딩을 여기에
    }
}
```

**규칙**
- `setAttributes/setHierarchy/setConstraints/setBindings` override는 반드시 **클래스 본문**에 위치 (extension 내 override 불가)
- `action: PublishRelay<Action>`과 `disposeBag`은 `BaseView`가 자동 제공 — 직접 선언 금지
- `configure()` 호출 불필요 — `init(frame:)` 시 자동 실행됨
- `convenience init() { self.init(frame: .zero) }` 는 `init()` 호출 사이트가 있을 때만 추가

---

## 2. setBindings() — ActionBinder 체인 패턴

### 2-1. ControlEvent / rx.tap (버튼, 리프레시 등)

```swift
// Void → 고정 Action
bind(submitButton.rx.tap).to(.tapSubmit)
bind(refreshControl.rx.controlEvent(.valueChanged)).to(.refresh)
```

### 2-2. Observable → 변환 필요

```swift
// Input을 Action으로 변환
bind(textField.rx.text.orEmpty.asObservable())
    .map { .updateName($0) }
```

### 2-3. CollectionView rx.itemSelected

```swift
// DataSource에서 모델 추출 → 변환
bind(collectionView.rx.itemSelected)
    .compactMap { [weak self] in self?.dataSource?.itemIdentifier(for: $0) }
    .map { .selectItem($0) }

// 여러 섹션/아이템 타입 분기
bind(collectionView.rx.itemSelected)
    .compactMap { [weak self] indexPath -> FooAction? in
        guard let item = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
        switch item {
        case let .chip(c): return .chipTap(c)
        case .moreButton: return .moreTap
        default: return nil
        }
    }
    .map { $0 }   // compactMap 후 Input == Action이면 .map { $0 }
```

### 2-4. CollectionView rx.itemSelected + rx.itemDeselected (다중 선택)

```swift
bind(
    Observable.merge(
        collectionView.rx.itemSelected.asObservable(),
        collectionView.rx.itemDeselected.asObservable()
    )
)
.compactMap { [weak self] in self?.dataSource?.itemIdentifier(for: $0) }
.map { $0 }
```

### 2-5. CollectionView rx.contentOffset (스크롤 감지)

```swift
bind(collectionView.rx.contentOffset)
    .filter { $0.y < 0 }
    .map { _ in .shouldDismiss }
```

### 2-6. 자식 BaseView의 action (relay 바인딩)

```swift
// 자식 View가 BaseView<ChildAction>일 때
bind(childView.action)
    .map { childAction -> FooAction in
        switch childAction {
        case let .tap(item): return .parentTap(item)
        case .close: return .parentClose
        }
    }
```

### 2-7. 클로저 기반 이벤트 (DSNavigationBar, 커스텀 컴포넌트)

```swift
// Void 클로저 → Action
bind(naviBar.onLeftTap).to(.tapBack)

// 값 있는 클로저 → Action
bind(someView.onSelectItem).map { .selectItem($0) }
```

### 2-8. ActionBinder 체인 메서드 요약

| 메서드 | 반환 | 용도 |
|--------|------|------|
| `.filter { bool }` | ActionBinder | 조건 필터링 |
| `.compactMap { T? }` | ActionBinder\<T\> | nil 제거 + 타입 변환 |
| `.throttle(.seconds(1))` | ActionBinder | 연속 탭 방지 |
| `.debounce(.milliseconds(300))` | ActionBinder | 검색 입력 딜레이 |
| `.withLatestFrom(relay)` | ActionBinder\<T\> | 다른 상태와 결합 |
| `.map { Action }` | *terminal* | 최종 Action 변환 후 발행 |
| `.to(.action)` | *terminal* | Void Input → 고정 Action |

> **terminal 메서드** 호출로 구독이 시작됨. 체인 마지막에 반드시 `.map { }` 또는 `.to()` 사용.

---

## 3. 안티패턴 (절대 금지)

```swift
// ❌ extension 내 override → 컴파일 에러
private extension FooView {
    override func setBindings() { ... }
}

// ❌ 개별 PublishRelay 선언 (BaseView<Action>으로 통합)
let itemTapped = PublishRelay<BarItem>()
let closeButtonTapped = PublishRelay<Void>()

// ❌ UICollectionViewDelegate 수동 구현 (rx 사용)
class FooView: BaseView<FooAction>, UICollectionViewDelegate { ... }

// ❌ force unwrap
let item = dataSource!.itemIdentifier(for: indexPath)!

// ❌ Combine (RxSwift 사용)
import Combine

// ❌ Storyboard / XIB (SnapKit 코드 UI 사용)
```

---

## 4. ViewController 연결

`BaseViewController`는 `contentView.action`을 `viewModel.action`으로 자동 바인딩한다.
`ContentView.Action == ViewModel.Action` 타입이 일치해야 한다.

```swift
final class FooViewController: BaseViewController<FooViewModel, FooView> {
    init(viewModel: FooViewModel) {
        super.init(viewModel: viewModel, contentView: FooView())
    }

    override func bindState() {
        viewModel.state
            .map(\.items)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] items in
                self?.contentView.render(items: items)
            })
            .disposed(by: disposeBag)
    }

    override func handleEvent(_ event: FooViewModel.Event) {
        switch event {
        case let .showToast(message): showToast(message)
        }
    }
}
```

---

## 5. 참고 파일 (실제 예시)

- **`BaseView`** 정의: `Projects/Presentation/Sources/Utill/Base/View/BaseView.swift`
- **`ActionBinder`**: `Projects/Presentation/Sources/Utill/Binding/ActionBinder.swift`
- **`ActionBindable+Bind`**: `Projects/Presentation/Sources/Utill/Binding/ActionBindable+Bind.swift`
- **단순 예시**: `Projects/Presentation/Sources/Scene/Auth/Category/CategoryView.swift`
- **CollectionView 예시**: `Projects/Presentation/Sources/Scene/Discovery/Discovery/Base/DiscoveryView.swift`
- **복잡한 예시**: `Projects/Presentation/Sources/Scene/Souvernir/Form/Base/SouvenirFormView.swift`
