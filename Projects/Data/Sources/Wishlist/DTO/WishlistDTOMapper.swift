import Domain

public enum WishlistDTOMapper {
    public static func toDomain(_ dto: WishlistMutationDataDTO) -> WishlistMutationResult {
        WishlistMutationResult(souvenirId: dto.souvenirId, isWishlisted: dto.wishlisted)
    }
}
