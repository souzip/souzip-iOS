public protocol DomainUserFactory: AnyObject {
    func makeUserRepository() -> UserRepository
    func makeUploadPromptBubbleUseCase() -> UploadPromptBubbleUseCase
}

public extension DefaultDomainFactory {
    func makeUserRepository() -> UserRepository {
        factory.makeUserRepository()
    }

    func makeUploadPromptBubbleUseCase() -> UploadPromptBubbleUseCase {
        DefaultUploadPromptBubbleUseCase(userRepository: factory.makeUserRepository())
    }
}
