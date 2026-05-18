import Domain
import Foundation
import Networking

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

    public static func pagedList<Item: Equatable>(
        items: [Item],
        pagination: PaginationDTO
    ) -> PagedList<Item> {
        PagedList(
            items: items,
            currentPage: pagination.currentPage,
            totalPages: pagination.totalPages,
            totalItems: pagination.totalItems,
            pageSize: pagination.pageSize,
            hasNext: pagination.hasNext,
            hasPrevious: pagination.hasPrevious
        )
    }

    public static func toUserSouvenirListPage(_ dto: UserSouvenirsResponse) -> UserSouvenirListPage {
        pagedList(
            items: dto.content.map { toCollectedSouvenirSummary($0) },
            pagination: dto.pagination
        )
    }

    public static func toPagedWishlistedSouvenirs(_ dto: UserWishlistsResponse) -> PagedList<WishlistedSouvenirRow> {
        pagedList(
            items: dto.content.map { toWishlistedSouvenirRow($0) },
            pagination: dto.pagination
        )
    }

    public static func toWishlistedSouvenirRow(_ dto: WishlistedSouvenirItemResponse) -> WishlistedSouvenirRow {
        WishlistedSouvenirRow(
            souvenirId: dto.souvenirId,
            name: dto.name,
            countryCode: dto.countryCode,
            thumbnailUrl: dto.thumbnailUrl,
            wishedAt: dto.wishedAt,
            isWishlisted: dto.isWishlisted
        )
    }

    public static func toCollectedSouvenirSummary(_ dto: SouvenirItemResponse) -> CollectedSouvenirSummary {
        CollectedSouvenirSummary(
            id: dto.id,
            thumbnailUrl: dto.thumbnailUrl,
            country: dto.countryCode,
            createdAt: dto.createdAt,
            updatedAt: dto.updatedAt,
            wishlistCount: dto.wishlistCount,
            isWishlisted: dto.isWishlisted
        )
    }
}
