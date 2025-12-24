import UIKit

final class CategoryViewController: BaseViewController<
    CategoryViewModel,
    CategoryView
> {
    // MARK: - Indicator

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.hidesWhenStopped = true
        return indicator
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingIndicator()
    }

    // MARK: - Bind

    override func bindState() {
        observe(\.items)
            .distinct()
            .onNext(contentView.render(items:))

        observe(\.canComplete)
            .distinct()
            .onNext(contentView.render(canComplete:))
    }

    // MARK: - Setup

    private func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)

        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    // MARK: - Event

    override func handleEvent(_ event: Event) {
        switch event {
        case let .showToast(message):
            showToast(message)
        case let .loading(isLoading):
            handleLoading(isLoading)
        case let .showAlert(message):
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
