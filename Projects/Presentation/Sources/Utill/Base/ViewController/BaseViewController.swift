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

    var isSwipeBackEnabled: Bool { true }

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
