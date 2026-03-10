public struct NoticeResponse: Decodable {
    public let id: Int
    public let title: String
    public let content: String
    public let createdAt: String
    public let files: [NoticeFileResponse]
}

public struct NoticeFileResponse: Decodable {
    public let url: String
    public let displayOrder: Int
}
