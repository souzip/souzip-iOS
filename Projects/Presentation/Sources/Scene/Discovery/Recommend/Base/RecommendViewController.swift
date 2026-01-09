import UIKit

final class RecommendViewController: BaseViewController<
    RecommendViewModel,
    RecommendView
> {
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.hidesWhenStopped = true
        return indicator
    }()

    // MARK: - LIfe Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingIndicator()
        viewModel.action.accept(.viewDidLoad)
    }

    // MARK: - Bind

    override func bindState() {
        observe(\.sectionModels)
            .onNext(contentView.render)
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
        case let .showErrorAlert(message):
            showDSAlert(message: message)
        case let .loading(isLoading):
            handleLoading(isLoading)
        }
    }

    // MARK: - Private

    private func handleLoading(_ isLoading: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
}
