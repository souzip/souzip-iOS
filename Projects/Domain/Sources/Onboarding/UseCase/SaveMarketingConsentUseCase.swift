public protocol SaveMarketingConsentUseCase {
    func execute(isAgreed: Bool)
}

public final class DefaultSaveMarketingConsentUseCase: SaveMarketingConsentUseCase {
    private let onboardingRepo: OnboardingRepository

    public init(onboardingRepo: OnboardingRepository) {
        self.onboardingRepo = onboardingRepo
    }

    public func execute(isAgreed: Bool) {
        onboardingRepo.saveMarketingConsent(isAgreed)
    }
}
