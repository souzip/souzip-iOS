import Logger
import RxCocoa
import RxRelay
import RxSwift
import UIKit

class BaseViewController<
    ViewModel: BaseViewModelType,
    ContentView: UIView & ActionBindable
>: UIViewController where ContentView.Action == ViewModel.Action {
    typealias Event = ViewModel.Event

    let viewModel: ViewModel
    let contentView: ContentView
    let disposeBag = DisposeBag()

    init(viewModel: ViewModel, contentView: ContentView) {
        self.viewModel = viewModel
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.shared.logLifecycle(caller: self)
        bindBase()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Logger.shared.logLifecycle(caller: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Logger.shared.logLifecycle(caller: self)
    }

    deinit {
        Logger.shared.logLifecycle(caller: self)
    }

    // MARK: - Base Binding

    private func bindBase() {
        contentView.action
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)

        viewModel.event
            .asSignal()
            .emit { [weak self] event in
                self?.handleEvent(event)
            }
            .disposed(by: disposeBag)

        bindState()
    }

    // MARK: - Override Points

    func bindState() {
        // Override in subclass
    }

    func handleEvent(_ event: Event) {
        // Override in subclass
    }
}

// MARK: - State 관찰 헬퍼 (선언형 방식)

extension BaseViewController {
    /// State 관찰 시작 (선언형)
    func observe<T: Equatable>(
        _ keyPath: KeyPath<ViewModel.State, T>
    ) -> StateObserver<T> {
        StateObserver(
            source: viewModel.state
                .asDriver()
                .map { $0[keyPath: keyPath] },
            disposeBag: disposeBag
        )
    }

    /// State 계산하여 관찰 시작 (선언형)
    func observeComputed<T: Equatable>(
        _ compute: @escaping (ViewModel.State) -> T
    ) -> StateObserver<T> {
        StateObserver(
            source: viewModel.state
                .asDriver()
                .map(compute),
            disposeBag: disposeBag
        )
    }
}

// MARK: - StateObserver

final class StateObserver<T: Equatable> {
    private var source: Driver<T>
    private let disposeBag: DisposeBag

    init(source: Driver<T>, disposeBag: DisposeBag) {
        self.source = source.distinctUntilChanged()
        self.disposeBag = disposeBag
    }

    func skip(_ num: Int) -> Self {
        source = source.skip(num)
        return self
    }

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

    func onNext(_ handler: @escaping (T) -> Void) {
        source
            .drive(onNext: handler)
            .disposed(by: disposeBag)
    }
}
