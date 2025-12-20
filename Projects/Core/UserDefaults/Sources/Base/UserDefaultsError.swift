public enum UserDefaultsError: Error {
    case encodingFailed(key: String, error: Error)
    case decodingFailed(key: String, error: Error)

    var errorDescription: String {
        switch self {
        case .encodingFailed:
            "데이터 인코딩에 실패했습니다."
        case .decodingFailed:
            "데이터 디코딩에 실패했습니다."
        }
    }
}
