import Logger
import RxRelay
import RxSwift

class BaseViewModel<State, Action, Event, Route>: BaseViewModelProtocol {
    let action = PublishRelay<Action>()
    let event = PublishRelay<Event>()
    let route = PublishRelay<Route>()

    private(set) var state: BehaviorRelay<State>
    let disposeBag = DisposeBag()

    // Protocol 구현
    var stateRelay: BehaviorRelay<State> { state }
    var actionRelay: PublishRelay<Action> { action }
    var eventRelay: PublishRelay<Event> { event }
    var routeRelay: PublishRelay<Route> { route }

    init(initialState: State) {
        state = BehaviorRelay(value: initialState)

        // Action 자동 바인딩
        action
            .subscribe { [weak self] action in
                Logger.shared.logAction(action)
                self?.handleAction(action)
            }
            .disposed(by: disposeBag)

        // State 바인딩 자동 호출
        bindState()
    }

    // 하위 클래스에서 override
    func bindState() {
        // Override in subclass
    }

    // 하위 클래스에서 override
    func handleAction(_ action: Action) {
        // Override in subclass
    }

    func mutate(_ mutation: @escaping (inout State) -> Void) {
        var newState = state.value
        mutation(&newState)
        state.accept(newState)
    }

    func emit(_ event: Event) {
        Logger.shared.logEvent(event)
        self.event.accept(event)
    }

    func navigate(to route: Route) {
        Logger.shared.logRoute(route)
        self.route.accept(route)
    }
}

// MARK: - State 관찰 헬퍼

extension BaseViewModel {
    /// State의 특정 속성을 관찰
    func observe<T: Equatable>(
        _ keyPath: KeyPath<State, T>,
        skip: Int = 1,
        onNext: @escaping (T) -> Void
    ) {
        state
            .map { $0[keyPath: keyPath] }
            .distinctUntilChanged()
            .skip(skip)
            .subscribe(onNext: onNext)
            .disposed(by: disposeBag)
    }

    /// State를 계산하여 관찰
    func observe<T: Equatable>(
        skip: Int = 1,
        compute: @escaping (State) -> T,
        onNext: @escaping (T) -> Void
    ) {
        state
            .map(compute)
            .distinctUntilChanged()
            .skip(skip)
            .subscribe(onNext: onNext)
            .disposed(by: disposeBag)
    }

    /// State를 관찰하고 자동으로 State 변경
    func observeAndMutate<T: Equatable>(
        skip: Int = 1,
        compute: @escaping (State) -> T,
        mutation: @escaping (inout State, T) -> Void
    ) {
        state
            .map(compute)
            .distinctUntilChanged()
            .skip(skip)
            .subscribe { [weak self] value in
                self?.mutate { mutation(&$0, value) }
            }
            .disposed(by: disposeBag)
    }
}
