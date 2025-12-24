public protocol DomainOnboardingFactory: AnyObject {
    func makeSaveMarketingConsentUseCase() -> SaveMarketingConsentUseCase
    func makeSaveNicknameUseCase() -> SaveNicknameUseCase
    func makeValidateNicknameUseCase() -> ValidateNicknameUseCase
    func makeSaveProfileImageColorUseCase() -> SaveProfileImageColorUseCase
    func makeSaveCategoriesUseCase() -> SaveCategoriesUseCase
    func makeCompleteOnboardingUseCase() -> CompleteOnboardingUseCase
}

public extension DefaultDomainFactory {
    func makeSaveMarketingConsentUseCase() -> SaveMarketingConsentUseCase {
        let onboardingRepo = factory.makeOnboardingRepository()
        return DefaultSaveMarketingConsentUseCase(onboardingRepo: onboardingRepo)
    }

    func makeSaveNicknameUseCase() -> SaveNicknameUseCase {
        let onboardingRepo = factory.makeOnboardingRepository()
        return DefaultSaveNicknameUseCase(onboardingRepo: onboardingRepo)
    }

    func makeValidateNicknameUseCase() -> ValidateNicknameUseCase {
        let onboardingRepo = factory.makeOnboardingRepository()
        return DefaultValidateNicknameUseCase(onboardingRepo: onboardingRepo)
    }

    func makeSaveProfileImageColorUseCase() -> SaveProfileImageColorUseCase {
        let onboardingRepo = factory.makeOnboardingRepository()
        return DefaultSaveProfileImageColorUseCase(onboardingRepo: onboardingRepo)
    }

    func makeSaveCategoriesUseCase() -> SaveCategoriesUseCase {
        let onboardingRepo = factory.makeOnboardingRepository()
        return DefaultSaveCategoriesUseCase(onboardingRepo: onboardingRepo)
    }

    func makeCompleteOnboardingUseCase() -> CompleteOnboardingUseCase {
        let onboardingRepo = factory.makeOnboardingRepository()
        return DefaultCompleteOnboardingUseCase(onboardingRepo: onboardingRepo)
    }
}
