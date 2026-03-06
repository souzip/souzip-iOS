public protocol UploadPromptBubbleUseCase {
    func shouldShowBubble() -> Bool
    func markViewed()
}

public final class DefaultUploadPromptBubbleUseCase: UploadPromptBubbleUseCase {
    private let userRepository: UserRepository

    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    public func shouldShowBubble() -> Bool {
        !userRepository.getHasVisitedMyPage()
    }

    public func markViewed() {
        userRepository.markMyPageVisited()
    }
}
