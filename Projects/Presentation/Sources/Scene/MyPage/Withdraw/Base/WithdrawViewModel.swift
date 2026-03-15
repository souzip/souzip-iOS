import Domain
import Foundation

final class WithdrawViewModel: BaseViewModel<
    WithdrawState,
    WithdrawAction,
    WithdrawEvent,
    MyPageRoute
> {
    // MARK: - Repository

    private let authRepo: AuthRepository

    // MARK: - Init

    init(authRepo: AuthRepository) {
        self.authRepo = authRepo
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
                try? await authRepo.withdraw()
                navigate(to: .withdrawComplete)
            }
        }
    }
}
