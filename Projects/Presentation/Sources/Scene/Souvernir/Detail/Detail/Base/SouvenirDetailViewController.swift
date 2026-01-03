import UIKit

final class SouvenirDetailViewController: BaseViewController<
    SouvenirDetailViewModel,
    SouvenirDetailView
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
        observe(\.detail)
            .unwrapped()
            .onNext(contentView.render(detail:))
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
        case let .loading(isLoading):
            handleLoading(isLoading)

        case let .showAlert(message):
            showDSAlert(message: message)

        case .showDeleteAlert:
            showDSConfirmAlert(
                message: "삭제하시겠습니까?",
                confirmTitle: "아니요",
                cancelTitle: "네, 삭제할께요",
                confirmHandler: nil
            ) { [weak self] in
                self?.viewModel.action.accept(.confirmDelete)
            }

        case .showReport:
            let sheet = ReportActionSheetViewController()
            sheet.modalPresentationStyle = .overFullScreen
            present(sheet, animated: false)
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
