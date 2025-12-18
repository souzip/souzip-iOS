import Domain
import Foundation

public enum AuthDTOMapper {
    public static func toDomain(_ dto: LoginResponse) -> LoginResult {
        LoginResult(
            nickname: dto.user.nickname,
            needsOnboarding: dto.needsOnboarding
        )
    }
}
