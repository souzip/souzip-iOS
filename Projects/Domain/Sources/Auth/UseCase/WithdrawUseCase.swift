public protocol WithdrawUseCase {
    func execute() async throws
}

public final class DefaultWithdrawUseCase: WithdrawUseCase {
    private let authRepo: AuthRepository

    public init(authRepo: AuthRepository) {
        self.authRepo = authRepo
    }

    public func execute() async throws {
        try await authRepo.withdraw()
    }
}
