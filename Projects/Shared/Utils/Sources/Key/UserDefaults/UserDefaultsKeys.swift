public enum UserDefaultsKeys {
    public static let userId =
        DefaultsKey<String>("user_id", default: "")

    public static let userNickname =
        DefaultsKey<String>("user_nickname", default: "")

    public static let needsOnboarding =
        DefaultsKey<Bool>("needs_onboarding", default: false)
}
