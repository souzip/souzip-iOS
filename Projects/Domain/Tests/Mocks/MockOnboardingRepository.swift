import XCTest
@testable import Domain

final class MockOnboardingRepository: OnboardingRepository {
    var badWords: Set<String> = []
    var checkNicknameResult = true
    var completeOnboardingResult: LoginUser = DomainTestFixtures.loginUser

    private(set) var checkNicknameCallCount = 0
    private(set) var saveMarketingConsentCallCount = 0
    private(set) var lastMarketingConsent: Bool?
    private(set) var saveNicknameCallCount = 0
    private(set) var lastSavedNickname: String?
    private(set) var saveProfileImageColorCallCount = 0
    private(set) var lastProfileImageColor: ProfileImageType?
    private(set) var saveCategoriesCallCount = 0
    private(set) var lastSavedCategories: [SouvenirCategory]?
    private(set) var completeOnboardingCallCount = 0

    func fetchBadWords() -> Set<String> {
        badWords
    }

    func checkNickname(_ nickname: String) async throws -> Bool {
        checkNicknameCallCount += 1
        return checkNicknameResult
    }

    func saveMarketingConsent(_ isAgreed: Bool) {
        saveMarketingConsentCallCount += 1
        lastMarketingConsent = isAgreed
    }

    func saveNickname(_ nickname: String) {
        saveNicknameCallCount += 1
        lastSavedNickname = nickname
    }

    func saveProfileImageColor(_ color: ProfileImageType) {
        saveProfileImageColorCallCount += 1
        lastProfileImageColor = color
    }

    func saveCategories(_ categories: [SouvenirCategory]) {
        saveCategoriesCallCount += 1
        lastSavedCategories = categories
    }

    func completeOnboarding() async throws -> LoginUser {
        completeOnboardingCallCount += 1
        return completeOnboardingResult
    }
}
