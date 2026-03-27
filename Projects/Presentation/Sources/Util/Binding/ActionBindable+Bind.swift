import RxCocoa
import RxRelay
import RxSwift

extension ActionBindable {
    // Observable
    func bind<T>(_ observable: Observable<T>) -> ActionBinder<T, Action> {
        ActionBinder(source: observable, sink: action, disposeBag: disposeBag)
    }

    func bind<T>(_ realy: PublishRelay<T>) -> ActionBinder<T, Action> {
        ActionBinder(source: realy.asObservable(), sink: action, disposeBag: disposeBag)
    }

    // ControlEvent
    func bind<T>(_ controlEvent: ControlEvent<T>) -> ActionBinder<T, Action> {
        ActionBinder(source: controlEvent.asObservable(), sink: action, disposeBag: disposeBag)
    }

    // ControlProperty
    func bind<T>(_ controlProperty: ControlProperty<T>) -> ActionBinder<T, Action> {
        ActionBinder(source: controlProperty.asObservable(), sink: action, disposeBag: disposeBag)
    }

    // Void closure registration
    func bind(_ register: @escaping (@escaping () -> Void) -> Void) -> ClosureActionBinder<Action> {
        ClosureActionBinder(register: register, sink: action)
    }

    // Generic closure registration
    func bind<T>(_ register: @escaping (@escaping (T) -> Void) -> Void) -> ClosureActionBinderWithValue<T, Action> {
        ClosureActionBinderWithValue(register: register, sink: action)
    }
}
