import SnapKit
import UIKit

final class LoginViewController: BaseViewController<
    LoginViewModel,
    LoginView
> {
    // MARK: - Properties

    private let loadingIndicator = UIActivityIndicatorView(style: .large)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingIndicator()
    }

    // MARK: - Setup

    private func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)

        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    // MARK: - Bind

    override func bindState() {
        observe(\.recentAuthProvider)
            .unwrapped()
            .onNext(contentView.render)
    }

    // MARK: - Event

    override func handleEvent(_ event: Event) {
        switch event {
        case let .loading(isLoading):
            handleLoading(isLoading)
        case let .errorAlert(message):
            showDSAlert(message: message)
        }
    }

    // MARK: - Private

    private func handleLoading(_ isLoading: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
            view.isUserInteractionEnabled = false
        } else {
            loadingIndicator.stopAnimating()
            view.isUserInteractionEnabled = true
        }
    }
}
