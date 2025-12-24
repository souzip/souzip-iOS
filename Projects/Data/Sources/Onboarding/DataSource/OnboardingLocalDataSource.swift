import Foundation
import UserDefaults
import Utils

public protocol OnboardingLocalDataSource {
    func saveMarketingConsent(_ isAgreed: Bool)
    func saveNickname(_ nickname: String)
    func saveProfileImageColor(_ color: String)
    func saveCategories(_ categories: [OnboardingCategoryDTO])

    func getTemporaryData() -> OnboardingTemporaryData?

    func clearTemporaryData()
}

public final class DefaultOnboardingLocalDataSource: OnboardingLocalDataSource {
    private let storage: UserDefaultsStorage

    public init(storage: UserDefaultsStorage) {
        self.storage = storage
    }

    // MARK: - Save

    public func saveMarketingConsent(_ isAgreed: Bool) {
        storage.set(isAgreed, for: OnboardingDefaultsKeys.isAgreedMarketingTerms)
    }

    public func saveNickname(_ nickname: String) {
        storage.set(nickname, for: OnboardingDefaultsKeys.nickname)
    }

    public func saveProfileImageColor(_ color: String) {
        storage.set(color, for: OnboardingDefaultsKeys.profileImageColor)
    }

    public func saveCategories(_ categories: [OnboardingCategoryDTO]) {
        try? storage.setEncodable(categories, for: OnboardingDefaultsKeys.selectedCategories)
    }

    // MARK: - Get

    public func getTemporaryData() -> OnboardingTemporaryData? {
        let marketingConsent = storage.get(OnboardingDefaultsKeys.isAgreedMarketingTerms)
        let nickname = storage.get(OnboardingDefaultsKeys.nickname)
        let profileImageColor = storage.get(OnboardingDefaultsKeys.profileImageColor)

        guard !nickname.isEmpty, !profileImageColor.isEmpty else {
            return nil
        }

        guard let categories: [OnboardingCategoryDTO] = (try? storage.getDecodable(
            from: OnboardingDefaultsKeys.selectedCategories
        )) ?? nil, !categories.isEmpty else {
            return nil
        }

        return OnboardingTemporaryData(
            marketingConsent: marketingConsent,
            nickname: nickname,
            profileImageColor: profileImageColor,
            categories: categories
        )
    }

    // MARK: - Clear

    public func clearTemporaryData() {
        storage.remove(OnboardingDefaultsKeys.isAgreedMarketingTerms)
        storage.remove(OnboardingDefaultsKeys.nickname)
        storage.remove(OnboardingDefaultsKeys.profileImageColor)
        storage.remove(OnboardingDefaultsKeys.selectedCategories)
    }
}
