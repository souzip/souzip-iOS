public protocol LogoutUseCase {
    func execute() async throws
}

public final class DefaultLogoutUseCase: LogoutUseCase {
    private let authRepo: AuthRepository
    private let deactivateFCMToken: DeactivateFCMTokenUseCase

    public init(
        authRepo: AuthRepository,
        deactivateFCMToken: DeactivateFCMTokenUseCase
    ) {
        self.authRepo = authRepo
        self.deactivateFCMToken = deactivateFCMToken
    }

    public func execute() async throws {
        try? await deactivateFCMToken.execute()
        try await authRepo.logout()
    }
}
