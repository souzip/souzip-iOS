public struct NoticeDetail: Equatable {
    public let id: Int
    public let title: String
    public let content: String
    public let createdAt: String
    public let imageURLs: [String]

    public init(
        id: Int,
        title: String,
        content: String,
        createdAt: String,
        imageURLs: [String]
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.imageURLs = imageURLs
    }
}
