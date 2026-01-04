import Foundation

public enum CountryError: LocalizedError {
    case unauthorized
    case serverError
    case notFound
    case networkError
    case unknown

    public var errorDescription: String? {
        switch self {
        case .unauthorized:
            "인증이 필요합니다. 다시 로그인해주세요."

        case .serverError:
            "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요."

        case .notFound:
            "요청한 정보를 찾을 수 없습니다."

        case .networkError:
            "네트워크 오류가 발생했습니다."

        case .unknown:
            "알 수 없는 오류가 발생했습니다."
        }
    }
}
