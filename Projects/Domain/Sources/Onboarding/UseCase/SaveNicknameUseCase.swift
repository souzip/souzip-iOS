public protocol SaveNicknameUseCase {
    func execute(nickname: String)
}

public final class DefaultSaveNicknameUseCase: SaveNicknameUseCase {
    private let onboardingRepo: OnboardingRepository

    public init(onboardingRepo: OnboardingRepository) {
        self.onboardingRepo = onboardingRepo
    }

    public func execute(nickname: String) {
        onboardingRepo.saveNickname(nickname)
    }
}
