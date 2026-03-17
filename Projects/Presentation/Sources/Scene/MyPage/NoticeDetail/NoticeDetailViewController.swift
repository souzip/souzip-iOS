import SnapKit
import UIKit

final class NoticeDetailViewController: BaseViewController<
    NoticeDetailViewModel,
    NoticeDetailView
> {
    // MARK: - UI

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingIndicator()
        viewModel.action.accept(.viewDidLoad)
    }

    // MARK: - Bind

    override func bindState() {
        observe(\.detail)
            .distinct()
            .unwrapped()
            .onNext(contentView.render)
    }

    // MARK: - Event

    override func handleEvent(_ event: Event) {
        switch event {
        case let .loading(isLoading):
            isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()

        case let .showAlert(message):
            showDSAlert(message: message)
        }
    }

    // MARK: - Private

    private func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
