public struct Notice: Hashable {
    public let id: Int
    public let title: String
    public let createdAt: String

    public init(id: Int, title: String, createdAt: String) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
    }
}
