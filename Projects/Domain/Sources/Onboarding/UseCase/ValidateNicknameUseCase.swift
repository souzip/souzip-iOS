import Foundation

public protocol ValidateNicknameUseCase {
    var policy: NicknameValidationPolicy { get }

    func execute(_ nickname: String) -> NicknameValidationResult
}

public final class DefaultValidateNicknameUseCase: ValidateNicknameUseCase {
    public let policy = NicknameValidationPolicy()

    public init() {}

    public func execute(_ nickname: String) -> NicknameValidationResult {
        let min = policy.minLength
        let max = policy.maxLength

        // 최대 길이 초과
        let limited = String(nickname.prefix(max))

        // 허용되지 않은 문자 검사
        let hasInvalidCharacter = limited.contains { character in
            !character.unicodeScalars.allSatisfy {
                policy.allowedCharacterSet.contains($0)
            }
        }

        if hasInvalidCharacter {
            return .invalid(
                nickname: limited,
                error: .invalidCharacters
            )
        }

        // 최소 길이만 에러
        if limited.count < min {
            return .invalid(
                nickname: limited,
                error: .tooShort(min: min)
            )
        }

        return .valid(nickname: limited)
    }
}
