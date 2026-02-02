import SafariServices
import UIKit

final class TermsViewController: BaseViewController<
    TermsViewModel,
    TermsView
> {
    // MARK: - Constants
    
    private typealias Strings = TermsConstants.Strings

    // MARK: - Bind

    override func bindState() {
        observe(\.items)
            .onNext(contentView.renderItems)

        observe(\.items.isRequiredAllAgreed)
            .onNext(contentView.renderAgreeButtonEnabled)
    }

    // MARK: - Event

    override func handleEvent(_ event: Event) {
        switch event {
        case .showMarketingConfirmAlert:
            showDSConfirmAlert(
                message: Strings.marketingConfirmMessage,
                confirmTitle: Strings.marketingConfirmTitle,
                cancelTitle: Strings.marketingCancelTitle
            ) {
                self.viewModel.action.accept(.confirmMarketing(true))
            } cancelHandler: {
                self.viewModel.action.accept(.confirmMarketing(false))
            }

        case let .showSFView(url):
            let vc = SFSafariViewController(url: url)
            vc.modalPresentationStyle = .pageSheet
            present(vc, animated: true)
        }
    }
}
