public struct SouvenirOwner {
    public let nickname: String
    public let profileImageUrl: String?

    public init(nickname: String, profileImageUrl: String?) {
        self.nickname = nickname
        self.profileImageUrl = profileImageUrl
    }
}
