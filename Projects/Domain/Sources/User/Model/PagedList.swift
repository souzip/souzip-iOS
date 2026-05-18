/// `content` + `pagination` 형태의 목록 API 응답을 도메인에서 공통 표현한다.
public struct PagedList<Item: Equatable>: Equatable {
    public let items: [Item]
    public let currentPage: Int
    public let totalPages: Int
    public let totalItems: Int
    public let pageSize: Int
    public let hasNext: Bool
    public let hasPrevious: Bool

    public init(
        items: [Item],
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
