import Foundation

public struct Notice: Hashable {
    public let id: Int
    public let title: String
    public let createdAt: Date

    public init(id: Int, title: String, createdAt: Date) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
    }
}
