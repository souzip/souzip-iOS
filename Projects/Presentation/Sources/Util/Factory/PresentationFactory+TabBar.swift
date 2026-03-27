import Domain

protocol PresentationTabBarFactory: AnyObject {
    func makeUploadPromptBubbleUseCase() -> UploadPromptBubbleUseCase
}

extension DefaultPresentationFactory: PresentationTabBarFactory {
    func makeUploadPromptBubbleUseCase() -> UploadPromptBubbleUseCase {
        domainFactory.makeUploadPromptBubbleUseCase()
    }
}
