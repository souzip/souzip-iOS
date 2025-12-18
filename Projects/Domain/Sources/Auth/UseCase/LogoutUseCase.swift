public protocol LogoutUseCase {
    func execute() async throws
}

public final class DefaultLogoutUseCase: LogoutUseCase {
    private let repo: AuthRepository

    public init(repo: AuthRepository) {
        self.repo = repo
    }

    public func execute() async throws {
        try await repo.logout()
    }
}
