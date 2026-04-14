import Domain
import Foundation

final class WithdrawViewModel: BaseViewModel<
    WithdrawState,
    WithdrawAction,
    WithdrawEvent,
    MyPageRoute
> {
    // MARK: - UseCase

    private let withdraw: WithdrawUseCase

    // MARK: - Init

    init(withdraw: WithdrawUseCase) {
        self.withdraw = withdraw
        super.init(initialState: State())
    }

    // MARK: - Action Handling

    override func handleAction(_ action: Action) {
        switch action {
        case .tapContinue:
            navigate(to: .pop)

        case .tapWithdraw:
            Task {
                mutate { $0.isLoading = true }
                try? await withdraw.execute()
                navigate(to: .withdrawComplete)
            }
        }
    }
}
