import Foundation

public enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case encodingError(Error)
    case serverError(statusCode: Int, message: String?)
    case unauthorized
    case unknown(Error)

    public var localizedDescription: String {
        switch self {
        case .invalidURL:
            "유효하지 않은 URL입니다."
        case .noData:
            "데이터가 없습니다."
        case let .decodingError(error):
            "디코딩 실패: \(error.localizedDescription)"
        case let .encodingError(error):
            "인코딩 실패: \(error.localizedDescription)"
        case let .serverError(statusCode, message):
            "서버 에러 (\(statusCode)): \(message ?? "알 수 없는 에러")"
        case .unauthorized:
            "인증이 필요합니다."
        case let .unknown(error):
            "알 수 없는 에러: \(error.localizedDescription)"
        }
    }
}
