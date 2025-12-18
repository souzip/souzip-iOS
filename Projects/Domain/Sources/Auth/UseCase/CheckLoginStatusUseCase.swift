public protocol CheckLoginStatusUseCase {
    func execute() async -> Bool
}

public final class DefaultCheckLoginStatusUseCase: CheckLoginStatusUseCase {
    private let repo: AuthRepository

    public init(repo: AuthRepository) {
        self.repo = repo
    }

    public func execute() async -> Bool {
        await repo.checkLoginStatus()
    }
}
