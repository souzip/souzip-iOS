import Foundation

public enum KeychainError: Error {
    case encodingFailed
    case decodingFailed
    case saveFailed(status: OSStatus)
    case loadFailed(status: OSStatus)
    case deleteFailed(status: OSStatus)

    var localizedDescription: String {
        switch self {
        case .encodingFailed:
            "데이터 인코딩에 실패했습니다."
        case .decodingFailed:
            "데이터 디코딩에 실패했습니다."
        case let .saveFailed(status):
            "저장에 실패했습니다. (status: \(status))"
        case let .loadFailed(status):
            "불러오기에 실패했습니다. (status: \(status))"
        case let .deleteFailed(status):
            "삭제에 실패했습니다. (status: \(status))"
        }
    }
}
