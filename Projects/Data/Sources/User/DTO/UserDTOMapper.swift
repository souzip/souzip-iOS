import Domain
import Foundation

public enum UserDTOMapper {
    // MARK: - 기존 매핑 (로그인용)

    public static func toDomain(_ dto: UserDTO) -> LoginUser {
        LoginUser(
            userId: dto.userId,
            nickname: dto.nickname,
            needsOnboarding: dto.needsOnboarding
        )
    }

    // MARK: - 프로필 매핑 (API 응답)

    public static func toDomain(_ dto: UserProfileResponse) -> UserProfile {
        UserProfile(
            userId: dto.userId,
            nickname: dto.nickname,
            email: dto.email,
            profileImageUrl: dto.profileImageUrl
        )
    }

    // MARK: - 기념품 목록 매핑 (API 응답)

    public static func toDomain(_ dto: UserSouvenirsResponse) -> [SouvenirThumbnail] {
        dto.content.map { toDomain($0) }
    }

    public static func toDomain(_ dto: SouvenirItemResponse) -> SouvenirThumbnail {
        SouvenirThumbnail(
            id: dto.id,
            thumbnailUrl: dto.thumbnailUrl,
            country: dto.countryCode,
            createdAt: dto.createdAt,
            updatedAt: dto.updatedAt
        )
    }
}
