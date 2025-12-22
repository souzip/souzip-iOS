import UIKit

final class TermsViewController: BaseViewController<
    TermsViewModel,
    TermsView
> {
    // MARK: - Bind

    override func bindState() {
        observe(\.items)
            .onNext(contentView.render)

        observe(\.items.isRequiredAllAgreed)
            .onNext(contentView.render)
    }

    // MARK: - Event

    override func handleEvent(_ event: Event) {
        switch event {
        case let .showMarketingConfirm(message):
            showDSConfirmAlert(
                message: message,
                confirmTitle: "동의",
                cancelTitle: "미동의"
            ) {
                self.viewModel.action.accept(.confirmMarketing(true))
            } cancelHandler: {
                self.viewModel.action.accept(.confirmMarketing(false))
            }
        }
    }
}
