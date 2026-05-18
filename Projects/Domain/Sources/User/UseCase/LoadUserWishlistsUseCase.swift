import Foundation

public protocol LoadUserWishlistsUseCase {
    func execute(page: Int, size: Int) async throws -> PagedList<WishlistedSouvenirRow>
}

public final class DefaultLoadUserWishlistsUseCase: LoadUserWishlistsUseCase {
    private let userRepo: UserRepository

    public init(userRepo: UserRepository) {
        self.userRepo = userRepo
    }

    public func execute(page: Int, size: Int) async throws -> PagedList<WishlistedSouvenirRow> {
        try await userRepo.getUserWishlists(page: page, size: size)
    }
}
