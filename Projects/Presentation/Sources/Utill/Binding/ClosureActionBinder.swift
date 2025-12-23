import RxRelay

public final class ClosureActionBinder<Action> {
    private let register: (@escaping () -> Void) -> Void
    private weak var sink: PublishRelay<Action>?

    public init(register: @escaping (@escaping () -> Void) -> Void, sink: PublishRelay<Action>) {
        self.register = register
        self.sink = sink
    }

    public func to(_ action: Action) {
        register { [weak sink] in
            sink?.accept(action)
        }
    }
}

public final class ClosureActionBinderWithValue<T, Action> {
    private let register: (@escaping (T) -> Void) -> Void
    private weak var sink: PublishRelay<Action>?

    public init(register: @escaping (@escaping (T) -> Void) -> Void, sink: PublishRelay<Action>) {
        self.register = register
        self.sink = sink
    }

    public func map(_ transform: @escaping (T) -> Action) {
        register { [weak sink] value in
            sink?.accept(transform(value))
        }
    }

    public func to(_ action: Action) {
        register { [weak sink] _ in
            sink?.accept(action)
        }
    }
}
