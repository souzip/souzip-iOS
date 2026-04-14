import Foundation

public protocol LoadUserSouvenirsUseCase {
    func execute() async throws -> [SouvenirThumbnail]
}

public final class DefaultLoadUserSouvenirsUseCase: LoadUserSouvenirsUseCase {
    private let userRepo: UserRepository

    public init(userRepo: UserRepository) {
        self.userRepo = userRepo
    }

    public func execute() async throws -> [SouvenirThumbnail] {
        try await userRepo.getUserSouvenirs()
    }
}
