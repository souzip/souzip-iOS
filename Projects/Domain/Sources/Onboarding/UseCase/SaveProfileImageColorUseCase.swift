public protocol SaveProfileImageColorUseCase {
    func execute(color: ProfileImageType)
}

public final class DefaultSaveProfileImageColorUseCase: SaveProfileImageColorUseCase {
    private let onboardingRepo: OnboardingRepository

    public init(onboardingRepo: OnboardingRepository) {
        self.onboardingRepo = onboardingRepo
    }

    public func execute(color: ProfileImageType) {
        onboardingRepo.saveProfileImageColor(color)
    }
}
