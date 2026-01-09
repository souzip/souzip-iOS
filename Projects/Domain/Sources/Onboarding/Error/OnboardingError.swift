import Foundation

public enum OnboardingError: Error, LocalizedError {
    case incompleteData
    case invalidNickname
    case networkFailed
    case saveFailed

    public var errorDescription: String? {
        switch self {
        case .incompleteData:
            "온보딩 데이터가 불완전합니다."
        case .invalidNickname:
            "이미 사용중인 닉네임입니다."
        case .networkFailed:
            "네트워크 요청에 실패했습니다."
        case .saveFailed:
            "데이터 저장에 실패했습니다."
        }
    }
}
