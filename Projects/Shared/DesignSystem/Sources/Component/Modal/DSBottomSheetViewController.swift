import SnapKit
import UIKit

open class DSBottomSheetViewController: UIViewController {
    // MARK: - Properties

    private let bottomSheetView = DSBottomSheetView()
    private var dismissHandler: (() -> Void)?

    // MARK: - Init

    public init(
        contentView: UIView,
    ) {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        bottomSheetView.setContentView(contentView)
        setupDimmingTapHandler()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override public func loadView() {
        view = bottomSheetView
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bottomSheetView.animateIn()
    }

    // MARK: - Setup

    private func setupDimmingTapHandler() {
        bottomSheetView.onDimmingTap = { [weak self] in
            self?.dismissSheet()
        }
    }

    // MARK: - Public API

    @discardableResult
    public func onDismiss(_ handler: @escaping () -> Void) -> Self {
        dismissHandler = handler
        return self
    }

    public func dismissSheet(completion: (() -> Void)? = nil) {
        bottomSheetView.animateOut { [weak self] in
            self?.dismiss(animated: false) {
                self?.dismissHandler?()
                completion?()
            }
        }
    }
}
