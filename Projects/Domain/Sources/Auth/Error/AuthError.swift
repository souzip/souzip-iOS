import Foundation

public enum AuthError: LocalizedError {
    case loginFailed
    case loginCancelled
    case expired
    case invalidToken
    case invalidUser
    case tokenStorageFailed
    case unsupportedProvider
    case networkError
    case unknown

    public var errorDescription: String? {
        switch self {
        case .loginFailed:
            "로그인에 실패했습니다."
        case .loginCancelled:
            "로그인이 취소되었습니다."
        case .expired:
            "세션이 만료되었습니다. 다시 로그인해주세요."
        case .invalidToken:
            "유효하지 않은 토큰입니다."
        case .invalidUser:
            "사용자 정보를 찾을 수 없습니다."
        case .tokenStorageFailed:
            "토큰 저장에 실패했습니다."
        case .unsupportedProvider:
            "지원하지 않는 로그인 방식입니다."
        case .networkError:
            "네트워크 오류가 발생했습니다."
        case .unknown:
            "알 수 없는 오류가 발생했습니다."
        }
    }
}
