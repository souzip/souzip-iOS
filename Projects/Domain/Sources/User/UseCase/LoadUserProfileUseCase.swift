import Foundation

public protocol LoadUserProfileUseCase {
    func execute() async throws -> UserProfile
}

public final class DefaultLoadUserProfileUseCase: LoadUserProfileUseCase {
    private let userRepo: UserRepository

    public init(userRepo: UserRepository) {
        self.userRepo = userRepo
    }

    public func execute() async throws -> UserProfile {
        try await userRepo.getUserProfile()
    }
}
