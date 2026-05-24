import Foundation
@testable import Domain

/// UseCase `validateLocally`와 동일한 문자 허용 판정 — Policy 계약 검증용.
enum NicknamePolicyTestSupport {
    static func isAllowed(_ character: Character, policy: NicknameValidationPolicy) -> Bool {
        character.unicodeScalars.allSatisfy {
            policy.allowedCharacterSet.contains($0)
        }
    }

    static func containsOnlyAllowedCharacters(_ string: String, policy: NicknameValidationPolicy) -> Bool {
        string.allSatisfy { isAllowed($0, policy: policy) }
    }
}
