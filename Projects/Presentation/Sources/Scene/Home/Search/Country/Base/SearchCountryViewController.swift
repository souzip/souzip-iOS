import SnapKit
import UIKit

final class SearchCountryViewController: BaseViewController<
    SearchCountryViewModel,
    SearchCountryView
> {
    // MARK: - UI

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.style = .large
        indicator.hidesWhenStopped = true
        return indicator
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingIndicator()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentView.focusSearchField()
    }

    // MARK: - Bind

    override func bindState() {
        observeState()
            .map { ($0.items, $0.searchText) }
            .onNext { [weak self] items, searchText in
                self?.contentView.render(items: items, searchText: searchText)
            }

        observe(\.isEmpty)
            .distinct()
            .onNext(contentView.render(isEmpty:))
    }

    // MARK: - Event

    override func handleEvent(_ event: Event) {
        switch event {
        case let .showAlert(message):
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

    private func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)

        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
