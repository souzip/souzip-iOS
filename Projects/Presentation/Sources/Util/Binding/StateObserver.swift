import RxCocoa
import RxSwift

final class StateObserver<T> {
    private var source: Driver<T>
    private let disposeBag: DisposeBag

    init(source: Driver<T>, disposeBag: DisposeBag) {
        self.source = source
        self.disposeBag = disposeBag
    }

    @discardableResult
    func skip(_ num: Int) -> Self {
        source = source.skip(num)
        return self
    }

    @discardableResult
    func take(_ count: Int) -> Self {
        source = source
            .asObservable()
            .take(count)
            .asDriver(onErrorDriveWith: .empty())
        return self
    }

    @discardableResult
    func when(_ condition: @escaping (T) -> Bool) -> Self {
        source = source.filter(condition)
        return self
    }

    func unwrapped<Wrapped>() -> StateObserver<Wrapped> where T == Wrapped? {
        StateObserver<Wrapped>(
            source: source.compactMap { $0 },
            disposeBag: disposeBag
        )
    }

    func map<U>(_ transform: @escaping (T) -> U) -> StateObserver<U> {
        StateObserver<U>(
            source: source.map(transform),
            disposeBag: disposeBag
        )
    }

    func onNext(_ handler: @escaping (T) -> Void) {
        source
            .drive(onNext: handler)
            .disposed(by: disposeBag)
    }
}

extension StateObserver where T: Equatable {
    @discardableResult
    func distinct() -> Self {
        source = source.distinctUntilChanged()
        return self
    }
}
