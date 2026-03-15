import UIKit

final class WithdrawCompleteViewController: BaseViewController<
    WithdrawCompleteViewModel,
    WithdrawCompleteView
> {
    override var isSwipeBackEnabled: Bool { false }

    // MARK: - Bind

    override func bindState() {}

    override func handleEvent(_ event: Event) {}
}
