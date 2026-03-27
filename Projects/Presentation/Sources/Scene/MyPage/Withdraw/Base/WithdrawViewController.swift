import UIKit

final class WithdrawViewController: BaseViewController<
    WithdrawViewModel,
    WithdrawView
> {
    // MARK: - Bind

    override func bindState() {
        observe(\.isLoading)
            .distinct()
            .onNext { [weak self] isLoading in
                self?.contentView.isUserInteractionEnabled = !isLoading
            }
    }

    override func handleEvent(_ event: Event) {}
}
