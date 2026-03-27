import Foundation

final class WithdrawCompleteViewModel: BaseViewModel<
    WithdrawCompleteState,
    WithdrawCompleteAction,
    WithdrawCompleteEvent,
    MyPageRoute
> {
    // MARK: - Init

    init() {
        super.init(initialState: State())
    }

    // MARK: - Action Handling

    override func handleAction(_ action: Action) {
        switch action {
        case .tapConfirm:
            navigate(to: .login)
        }
    }
}
