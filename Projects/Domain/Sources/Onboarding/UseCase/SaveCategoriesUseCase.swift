public protocol SaveCategoriesUseCase {
    func execute(categories: [SouvenirCategory])
}

public final class DefaultSaveCategoriesUseCase: SaveCategoriesUseCase {
    private let onboardingRepo: OnboardingRepository

    public init(onboardingRepo: OnboardingRepository) {
        self.onboardingRepo = onboardingRepo
    }

    public func execute(categories: [SouvenirCategory]) {
        onboardingRepo.saveCategories(categories)
    }
}
