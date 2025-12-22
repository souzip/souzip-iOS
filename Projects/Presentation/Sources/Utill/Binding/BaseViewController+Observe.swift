import RxCocoa

extension BaseViewController {
    func observeState() -> StateObserver<ViewModel.State> {
        StateObserver(source: viewModel.state.asDriver(), disposeBag: disposeBag)
    }

    func observe<T: Equatable>(_ keyPath: KeyPath<ViewModel.State, T>) -> StateObserver<T> {
        observeState()
            .map { $0[keyPath: keyPath] }
            .distinct() // ✅ 여기서만 distinct 자동 적용
    }
}
