import Foundation

public enum OnboardingDefaultsKeys {
    public static let isAgreedMarketingTerms =
        DefaultsKey<Bool>("is_agreed_marketing_terms", default: false)

    public static let nickname =
        DefaultsKey<String>("onboarding_nickname", default: "")

    public static let profileImageColor =
        DefaultsKey<String>("profile_image_color", default: "")

    public static let selectedCategories =
        DefaultsKey<Data?>("selected_categories", default: nil)
}
