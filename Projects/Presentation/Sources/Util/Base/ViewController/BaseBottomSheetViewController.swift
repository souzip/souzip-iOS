import DesignSystem
import Logger
import RxCocoa
import RxRelay
import RxSwift
import UIKit

class BaseBottomSheetViewController<
    ViewModel: BaseViewModelType,
    ContentView: UIView & ActionBindable
>: DSBottomSheetViewController where ContentView.Action == ViewModel.Action {
    typealias Event = ViewModel.Event

    let viewModel: ViewModel
    let contentViewInstance: ContentView
    let disposeBag = DisposeBag()

    init(viewModel: ViewModel, contentView: ContentView) {
        self.viewModel = viewModel
        contentViewInstance = contentView
        super.init(contentView: contentView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.shared.logLifecycle(caller: self)
        bindBase()
    }

    deinit {
        Logger.shared.logLifecycle(caller: self)
    }

    // MARK: - Base Binding

    private func bindBase() {
        contentViewInstance.action
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)

        viewModel.event
            .asSignal()
            .emit { [weak self] event in
                self?.handleEvent(event)
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Override Points

    func handleEvent(_ event: Event) {
        // Override in subclass
    }
}
