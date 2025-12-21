import Domain
import Foundation

public enum AuthDTOMapper {
    public static func toDomain(_ dto: LoginResponse) -> LoginUser {
        LoginUser(
            userId: dto.user.nickname,
            needsOnboarding: dto.needsOnboarding
        )
    }
}
