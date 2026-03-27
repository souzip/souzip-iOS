import RxCocoa

extension BaseViewModel {
    func observeState() -> StateObserver<State> {
        StateObserver(source: state.asDriver(), disposeBag: disposeBag)
    }

    func observe<T: Equatable>(_ keyPath: KeyPath<State, T>) -> StateObserver<T> {
        observeState()
            .map { $0[keyPath: keyPath] }
            .distinct()
    }
}
