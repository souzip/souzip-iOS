public protocol DomainUserFactory: AnyObject {
    func makeUserRepository() -> UserRepository
    func makeUploadPromptBubbleUseCase() -> UploadPromptBubbleUseCase
    func makeLoadUserProfileUseCase() -> LoadUserProfileUseCase
    func makeLoadUserSouvenirsUseCase() -> LoadUserSouvenirsUseCase
    func makeLoadUserWishlistsUseCase() -> LoadUserWishlistsUseCase
}

public extension DefaultDomainFactory {
    func makeUserRepository() -> UserRepository {
        factory.makeUserRepository()
    }

    func makeUploadPromptBubbleUseCase() -> UploadPromptBubbleUseCase {
        DefaultUploadPromptBubbleUseCase(userRepository: factory.makeUserRepository())
    }

    func makeLoadUserProfileUseCase() -> LoadUserProfileUseCase {
        DefaultLoadUserProfileUseCase(userRepo: makeUserRepository())
    }

    func makeLoadUserSouvenirsUseCase() -> LoadUserSouvenirsUseCase {
        DefaultLoadUserSouvenirsUseCase(userRepo: makeUserRepository())
    }

    func makeLoadUserWishlistsUseCase() -> LoadUserWishlistsUseCase {
        DefaultLoadUserWishlistsUseCase(userRepo: makeUserRepository())
    }
}
