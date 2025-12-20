public protocol LoadRecentAuthProvider {
    func execute() async -> AuthProvider?
}

public final class DefaultLoadRecentAuthProvider: LoadRecentAuthProvider {
    private let authRepo: AuthRepository

    public init(authRepo: AuthRepository) {
        self.authRepo = authRepo
    }

    public func execute() async -> AuthProvider? {
        authRepo.loadRecentLoginProvider()
    }
}
