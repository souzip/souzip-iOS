import Domain

public enum UserDTOMapper {
    public static func toDomain(_ dto: UserDTO) -> LoginUser {
        LoginUser(
            userId: dto.userId,
            nickname: dto.nickname,
            needsOnboarding: dto.needsOnboarding
        )
    }
}
