public struct LoginUser {
    public let userId: String
    public let nickname: String
    public let needsOnboarding: Bool

    public init(
        userId: String,
        nickname: String,
        needsOnboarding: Bool
    ) {
        self.userId = userId
        self.nickname = nickname
        self.needsOnboarding = needsOnboarding
    }
}
