import Foundation

/// 여러 목록 API에서 공통으로 쓰이는 `pagination` 객체 JSON 매핑.
public struct PaginationDTO: Decodable {
    public let currentPage: Int
    public let totalPages: Int
    public let totalItems: Int
    public let pageSize: Int
    public let first: Bool
    public let last: Bool
    public let hasNext: Bool
    public let hasPrevious: Bool
}
