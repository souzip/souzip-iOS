public struct UserSouvenirListPage: Equatable {
    public let items: [CollectedSouvenirSummary]
    public let currentPage: Int
    public let totalPages: Int
    public let totalItems: Int
    public let pageSize: Int
    public let hasNext: Bool
    public let hasPrevious: Bool

    public init(
        items: [CollectedSouvenirSummary],
        currentPage: Int,
        totalPages: Int,
        totalItems: Int,
        pageSize: Int,
        hasNext: Bool,
        hasPrevious: Bool
    ) {
        self.items = items
        self.currentPage = currentPage
        self.totalPages = totalPages
        self.totalItems = totalItems
        self.pageSize = pageSize
        self.hasNext = hasNext
        self.hasPrevious = hasPrevious
    }
}
