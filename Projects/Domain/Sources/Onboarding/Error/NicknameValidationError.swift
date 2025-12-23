import Foundation

public enum NicknameValidationError: LocalizedError {
    case invalidCharacters
    case tooShort(min: Int)

    public var errorDescription: String? {
        switch self {
        case .invalidCharacters:
            "닉네임은 한글, 영문, 숫자만 사용할 수 있습니다."
        case let .tooShort(min):
            "닉네임은 최소 \(min)자 이상이어야 합니다."
        }
    }
}
