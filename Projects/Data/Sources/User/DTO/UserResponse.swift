import Foundation
import Networking

// MARK: - Profile (프로필 조회 API 응답)

public struct UserProfileResponse: Decodable {
    public let userId: String
    public let nickname: String
    public let email: String
    public let profileImageUrl: String
}

// MARK: - Souvenirs (기념품 목록 API 응답)

public struct UserSouvenirsResponse: Decodable {
    public let content: [SouvenirItemResponse]
    public let pagination: PaginationDTO
}

public struct SouvenirItemResponse: Decodable {
    public let id: Int
    public let thumbnailUrl: String
    public let countryCode: String
    public let createdAt: String
    public let updatedAt: String
    public let wishlistCount: Int
    public let isWishlisted: Bool
}
