import DesignSystem
import SafariServices
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
            showReportBottomSheet()

        case let .copy(address):
            UIPasteboard.general.string = address
            showToast("주소가 복사되었습니다")
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

    private func showReportBottomSheet() {
        let contentView = ReportBottomSheetView()
        let vc = presentBottomSheet(contentView: contentView)

        contentView.action
            .bind { [weak self, weak vc] action in
                switch action {
                case .report:
                    let urlString = """
                    https://docs.google.com/forms/d/e/1FAIpQLSeI3EI2-KKDzv5fCpfOuGdrjDjHxKN212SFNym0exyNVoLgHg/viewform
                    """
                    guard let url = URL(string: urlString) else { return }

                    vc?.dismissSheet { [weak self] in
                        let safariVC = SFSafariViewController(url: url)
                        safariVC.modalPresentationStyle = .pageSheet
                        self?.present(safariVC, animated: true)
                    }

                case .close:
                    vc?.dismissSheet()
                }
            }
            .disposed(by: disposeBag)
    }
}
