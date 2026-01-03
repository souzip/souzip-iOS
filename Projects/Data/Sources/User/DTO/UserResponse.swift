import Foundation

// MARK: - Profile (프로필 조회 API 응답)

public struct UserProfileResponse: Decodable {
    public let userId: String
    public let nickname: String
    public let email: String
    public let profileImageUrl: String
}

// MARK: - Souvenirs (기념품 목록 API 응답)

public struct UserSouvenirsResponse: Decodable {
    public let souvenirs: [SouvenirItemResponse]
    public let pagination: PaginationResponse
}

public struct SouvenirItemResponse: Decodable {
    public let id: Int
    public let thumbnailUrl: String
    public let country: String
    public let createdAt: String
    public let updatedAt: String
}

public struct PaginationResponse: Decodable {
    public let currentPage: Int
    public let pageSize: Int
    public let totalElements: Int
    public let totalPages: Int
    public let hasNext: Bool
}
