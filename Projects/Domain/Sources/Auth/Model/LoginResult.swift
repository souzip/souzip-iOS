public struct LoginResult {
    public let nickname: String
    public let needsOnboarding: Bool

    public init(
        nickname: String,
        needsOnboarding: Bool
    ) {
        self.nickname = nickname
        self.needsOnboarding = needsOnboarding
    }
}
