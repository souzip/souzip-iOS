import Logger
import RxRelay
import RxSwift
import UIKit

class BaseViewController<
    ViewModel: BaseViewModelProtocol,
    ContentView: UIView
>: UIViewController {
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
        Logger.shared.logLifecycle()
        setEventBinding()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Logger.shared.logLifecycle()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Logger.shared.logLifecycle()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Logger.shared.logLifecycle()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Logger.shared.logLifecycle()
    }

    deinit {
        Logger.shared.logLifecycle()
    }

    private func setEventBinding() {
        viewModel.eventRelay
            .subscribe { [weak self] event in
                guard let self else { return }
                handleEvent(event)
            }
            .disposed(by: disposeBag)
    }

    func bind() {
        // Override in subclass
    }

    func handleEvent(_ event: ViewModel.Event) {
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
        viewModel.stateRelay
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
        viewModel.stateRelay
            .map(compute)
            .distinctUntilChanged()
            .skip(skipInitial ? 1 : 0)
            .subscribe(onNext: onNext)
            .disposed(by: disposeBag)
    }
}
