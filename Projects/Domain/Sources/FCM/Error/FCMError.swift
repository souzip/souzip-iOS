import Foundation

public enum FCMError: Error, LocalizedError {
    case serverError
    case networkError
    case unknown

    public var errorDescription: String? {
        switch self {
        case .serverError:
            "서버에 문제가 발생했어요. 잠시 후 다시 시도해주세요."
        case .networkError:
            "네트워크 연결이 원활하지 않아요. 인터넷 상태를 확인해주세요."
        case .unknown:
            "알 수 없는 오류가 발생했어요. 다시 시도해주세요."
        }
    }
}
