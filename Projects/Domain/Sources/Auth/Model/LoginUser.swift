public struct LoginUser {
    public let userId: String
    public let needsOnboarding: Bool

    public init(
        userId: String,
        needsOnboarding: Bool
    ) {
        self.userId = userId
        self.needsOnboarding = needsOnboarding
    }
}
