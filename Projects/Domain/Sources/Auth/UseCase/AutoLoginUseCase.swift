public protocol AutoLoginUseCase {
    func execute() async -> LoginResult?
}

public final class DefaultAutoLoginUseCase: AutoLoginUseCase {
    private let authRepo: AuthRepository

    public init(authRepo: AuthRepository) {
        self.authRepo = authRepo
    }

    public func execute() async -> LoginResult? {
        let isLoggedIn = await authRepo.checkLoginStatus()
        guard isLoggedIn else {
            return nil
        }

        do {
            return try await authRepo.refreshToken()
        } catch {
            return nil
        }
    }
}
