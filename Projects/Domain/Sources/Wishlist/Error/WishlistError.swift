import Foundation

public enum WishlistError: LocalizedError {
    case unauthorized
    case noData
    case mutationFailed
    case conflict
    case unknown

    public var errorDescription: String? {
        switch self {
        case .unauthorized:
            "인증이 필요합니다. 다시 로그인해주세요."
        case .noData:
            "데이터를 찾을 수 없습니다."
        case .mutationFailed:
            "찜 처리에 실패했습니다."
        case .conflict:
            "이미 처리된 기념품이에요."
        case .unknown:
            "알 수 없는 오류가 발생했습니다."
        }
    }
}
