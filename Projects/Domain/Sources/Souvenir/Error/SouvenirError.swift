import Foundation

public enum SouvenirError: Error {
    case unauthorized
    case notFound
    case forbidden
    case serverError
    case networkError
    case invalidInput
    case imageUploadFailed
    case unknown
}

extension SouvenirError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unauthorized:
            "로그인이 필요해요. 다시 로그인해주세요."

        case .forbidden:
            "이 작업을 수행할 권한이 없어요."

        case .notFound:
            "요청한 기념품을 찾을 수 없어요."

        case .invalidInput:
            "입력한 정보가 올바르지 않아요. 다시 확인해주세요."

        case .imageUploadFailed:
            "이미지 업로드에 실패했어요. 잠시 후 다시 시도해주세요."

        case .networkError:
            "네트워크 연결이 원활하지 않아요. 인터넷 상태를 확인해주세요."

        case .serverError:
            "서버에 문제가 발생했어요. 잠시 후 다시 시도해주세요."

        case .unknown:
            "알 수 없는 오류가 발생했어요. 다시 시도해주세요."
        }
    }
}
