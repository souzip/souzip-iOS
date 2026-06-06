import Foundation
@testable import Domain

final class MockOnboardingRepository: OnboardingRepository {
    var stubCompleteOnboardingUser = LoginUser(
        userId: "user-1",
        nickname: "tester",
        needsOnboarding: false
    )
    var stubCheckNicknameResult = true
    var stubBadWords: Set<String> = []

    var completeOnboardingError: Error?
    var checkNicknameError: Error?

    private(set) var saveMarketingConsentCallCount = 0
    private(set) var lastMarketingConsent: Bool?

    private(set) var saveNicknameCallCount = 0
    private(set) var lastNickname: String?

    private(set) var saveProfileImageColorCallCount = 0
    private(set) var lastProfileImageColor: ProfileImageType?

    private(set) var saveCategoriesCallCount = 0
    private(set) var lastCategories: [SouvenirCategory]?

    private(set) var completeOnboardingCallCount = 0
    private(set) var checkNicknameCallCount = 0
    private(set) var lastCheckedNickname: String?

    private(set) var fetchBadWordsCallCount = 0

    func saveMarketingConsent(_ isAgreed: Bool) {
        saveMarketingConsentCallCount += 1
        lastMarketingConsent = isAgreed
    }

    func saveNickname(_ nickname: String) {
        saveNicknameCallCount += 1
        lastNickname = nickname
    }

    func saveProfileImageColor(_ color: ProfileImageType) {
        saveProfileImageColorCallCount += 1
        lastProfileImageColor = color
    }

    func saveCategories(_ categories: [SouvenirCategory]) {
        saveCategoriesCallCount += 1
        lastCategories = categories
    }

    func completeOnboarding() async throws -> LoginUser {
        completeOnboardingCallCount += 1

        if let completeOnboardingError {
            throw completeOnboardingError
        }

        return stubCompleteOnboardingUser
    }

    func checkNickname(_ nickname: String) async throws -> Bool {
        checkNicknameCallCount += 1
        lastCheckedNickname = nickname

        if let checkNicknameError {
            throw checkNicknameError
        }

        return stubCheckNicknameResult
    }

    func fetchBadWords() -> Set<String> {
        fetchBadWordsCallCount += 1
        return stubBadWords
    }
}

enum MockOnboardingError: Error {
    case failed
}
