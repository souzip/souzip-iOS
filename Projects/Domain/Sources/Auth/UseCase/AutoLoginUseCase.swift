public protocol AutoLoginUseCase {
    func execute() async -> AutoLoginResult
}

public final class DefaultAutoLoginUseCase: AutoLoginUseCase {
    private let authRepo: AuthRepository

    public init(authRepo: AuthRepository) {
        self.authRepo = authRepo
    }

    public func execute() async -> AutoLoginResult {
        let isLoggedIn = await authRepo.checkLoginStatus()
        guard isLoggedIn else {
            return .shouldLogin
        }

        guard let result = try? await authRepo.refreshToken() else {
            return .shouldLogin
        }

        if result.needsOnboarding {
            return .shouldLogin
        }

        return .ready
    }
}
