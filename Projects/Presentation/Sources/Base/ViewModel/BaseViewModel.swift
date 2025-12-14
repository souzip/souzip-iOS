import Logger
import RxRelay
import RxSwift

class BaseViewModel<State, Action, Event, Route>: BaseViewModelType {
    // MARK: - Relays

    let state: BehaviorRelay<State>
    let action = PublishRelay<Action>()
    let event = PublishRelay<Event>()
    let route = PublishRelay<Route>()

    let disposeBag = DisposeBag()

    init(initialState: State) {
        state = BehaviorRelay(value: initialState)

        action
            .subscribe { [weak self] action in
                Logger.shared.logAction(action, caller: self)
                self?.handleAction(action)
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Override Points

    func bindState() {
        // Override in subclass
    }

    func handleAction(_ action: Action) {
        // Override in subclass
    }

    // MARK: - State Mutation

    func mutate(_ mutation: @escaping (inout State) -> Void) {
        var newState = state.value
        mutation(&newState)
        state.accept(newState)
    }

    // MARK: - Event & Route

    func emit(_ event: Event) {
        Logger.shared.logEvent(event, caller: self)
        self.event.accept(event)
    }

    func navigate(to route: Route) {
        Logger.shared.logRoute(route, caller: self)
        self.route.accept(route)
    }
}

// MARK: - State 관찰 헬퍼

extension BaseViewModel {
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
