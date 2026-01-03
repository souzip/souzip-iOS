public struct UserProfile {
    public let userId: String
    public let nickname: String
    public let email: String
    public let profileImageUrl: String

    public init(
        userId: String,
        nickname: String,
        email: String,
        profileImageUrl: String
    ) {
        self.userId = userId
        self.nickname = nickname
        self.email = email
        self.profileImageUrl = profileImageUrl
    }
}
