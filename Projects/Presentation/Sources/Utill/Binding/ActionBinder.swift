import RxRelay
import RxSwift

public final class ActionBinder<Input, Action> {
    private let source: Observable<Input>
    private let sink: PublishRelay<Action>
    private let disposeBag: DisposeBag

    public init(source: Observable<Input>, sink: PublishRelay<Action>, disposeBag: DisposeBag) {
        self.source = source
        self.sink = sink
        self.disposeBag = disposeBag
    }

    @discardableResult
    public func filter(_ isIncluded: @escaping (Input) -> Bool) -> ActionBinder<Input, Action> {
        ActionBinder(
            source: source.filter(isIncluded),
            sink: sink,
            disposeBag: disposeBag
        )
    }

    @discardableResult
    public func throttle(_ interval: RxTimeInterval, scheduler: SchedulerType = MainScheduler.instance)
        -> ActionBinder<Input, Action> {
        ActionBinder(
            source: source.throttle(interval, scheduler: scheduler),
            sink: sink,
            disposeBag: disposeBag
        )
    }

    @discardableResult
    public func debounce(_ interval: RxTimeInterval, scheduler: SchedulerType = MainScheduler.instance)
        -> ActionBinder<Input, Action> {
        ActionBinder(
            source: source.debounce(interval, scheduler: scheduler),
            sink: sink,
            disposeBag: disposeBag
        )
    }

    public func map(_ transform: @escaping (Input) -> Action) {
        source
            .map(transform)
            .bind(to: sink)
            .disposed(by: disposeBag)
    }

    public func to(_ action: Action) where Input == Void {
        source
            .map { action }
            .bind(to: sink)
            .disposed(by: disposeBag)
    }

    @discardableResult
    public func withLatestFrom<T>(_ relay: BehaviorRelay<T>) -> ActionBinder<T, Action> {
        ActionBinder<T, Action>(
            source: source.withLatestFrom(relay),
            sink: sink,
            disposeBag: disposeBag
        )
    }

    @discardableResult
    public func compactMap<T>(_ transform: @escaping (Input) -> T?) -> ActionBinder<T, Action> {
        ActionBinder<T, Action>(
            source: source.compactMap(transform),
            sink: sink,
            disposeBag: disposeBag
        )
    }
}
