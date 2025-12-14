import Logger
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
            .subscribe { [weak self] event in
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

// MARK: - State 관찰 헬퍼

extension BaseViewController {
    /// State의 특정 속성을 관찰
    func observe<T: Equatable>(
        _ keyPath: KeyPath<ViewModel.State, T>,
        skipInitial: Bool = false,
        onNext: @escaping (T) -> Void
    ) {
        viewModel.state
            .map { $0[keyPath: keyPath] }
            .distinctUntilChanged()
            .skip(skipInitial ? 1 : 0)
            .subscribe(onNext: onNext)
            .disposed(by: disposeBag)
    }

    /// State를 계산하여 관찰
    func observe<T: Equatable>(
        compute: @escaping (ViewModel.State) -> T,
        skipInitial: Bool = false,
        onNext: @escaping (T) -> Void
    ) {
        viewModel.state
            .map(compute)
            .distinctUntilChanged()
            .skip(skipInitial ? 1 : 0)
            .subscribe(onNext: onNext)
            .disposed(by: disposeBag)
    }
}
