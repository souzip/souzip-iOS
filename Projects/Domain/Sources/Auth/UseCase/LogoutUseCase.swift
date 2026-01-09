public protocol LogoutUseCase {
    func execute() async throws
}

public final class DefaultLogoutUseCase: LogoutUseCase {
    private let authRepo: AuthRepository

    public init(authRepo: AuthRepository) {
        self.authRepo = authRepo
    }

    public func execute() async throws {
        try await authRepo.logout()
    }
}
