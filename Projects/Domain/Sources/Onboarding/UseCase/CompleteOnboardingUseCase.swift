public protocol CompleteOnboardingUseCase {
    func execute() async throws -> LoginUser
}

public final class DefaultCompleteOnboardingUseCase: CompleteOnboardingUseCase {
    private let onboardingRepo: OnboardingRepository

    public init(onboardingRepo: OnboardingRepository) {
        self.onboardingRepo = onboardingRepo
    }

    public func execute() async throws -> LoginUser {
        try await onboardingRepo.completeOnboarding()
    }
}
