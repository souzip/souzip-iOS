import Foundation

public enum UserError: LocalizedError {
    case unauthorized
    case noData
    case fetchFailed
    case profileLoadFailed
    case souvenirsLoadFailed
    case networkError
    case unknown

    public var errorDescription: String? {
        switch self {
        case .unauthorized:
            "인증이 필요합니다. 다시 로그인해주세요."
        case .noData:
            "데이터를 찾을 수 없습니다."
        case .fetchFailed:
            "정보를 불러오는데 실패했습니다."
        case .profileLoadFailed:
            "프로필을 불러오는데 실패했습니다."
        case .souvenirsLoadFailed:
            "기념품 목록을 불러오는데 실패했습니다."
        case .networkError:
            "네트워크 오류가 발생했습니다."
        case .unknown:
            "알 수 없는 오류가 발생했습니다."
        }
    }
}
