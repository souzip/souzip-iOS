import RxCocoa
import RxSwift

protocol ActionBindable: AnyObject {
    associatedtype Action

    var action: PublishRelay<Action> { get }
    var disposeBag: DisposeBag { get }
}

// MARK: - Binding Helpers

extension ActionBindable {
    /// Observable<T>를 매핑하여 Action으로 바인딩
    func bind<T>(_ observable: Observable<T>, to mapper: @escaping (T) -> Action) {
        observable
            .map(mapper)
            .bind(to: action)
            .disposed(by: disposeBag)
    }

    /// Observable<Void>를 고정 Action으로 바인딩
    func bind(_ observable: Observable<Void>, to fixedAction: Action) {
        observable
            .map { fixedAction }
            .bind(to: action)
            .disposed(by: disposeBag)
    }

    /// ControlEvent<T>를 매핑하여 Action으로 바인딩
    func bind<T>(_ controlEvent: ControlEvent<T>, to mapper: @escaping (T) -> Action) {
        controlEvent
            .map(mapper)
            .bind(to: action)
            .disposed(by: disposeBag)
    }

    /// ControlEvent<Void>를 고정 Action으로 바인딩
    func bind(_ controlEvent: ControlEvent<Void>, to fixedAction: Action) {
        controlEvent
            .map { fixedAction }
            .bind(to: action)
            .disposed(by: disposeBag)
    }

    /// ControlProperty<T>를 매핑하여 Action으로 바인딩
    func bind<T>(_ controlProperty: ControlProperty<T>, to mapper: @escaping (T) -> Action) {
        controlProperty
            .map(mapper)
            .bind(to: action)
            .disposed(by: disposeBag)
    }
}
