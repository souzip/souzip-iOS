import Foundation

public protocol LoadUserSouvenirsUseCase {
    func execute(page: Int, size: Int) async throws -> UserSouvenirListPage
}

public final class DefaultLoadUserSouvenirsUseCase: LoadUserSouvenirsUseCase {
    private let userRepo: UserRepository

    public init(userRepo: UserRepository) {
        self.userRepo = userRepo
    }

    public func execute(page: Int, size: Int) async throws -> UserSouvenirListPage {
        try await userRepo.getUserSouvenirs(page: page, size: size)
    }
}
