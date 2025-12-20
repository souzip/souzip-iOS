enum OAuthServiceError: Error {
    case cancelled
    case notSupported
    case sdkError(Error)
    case unknown(Error)

    var localizedDescription: String {
        switch self {
        case .cancelled:
            "로그인이 취소되었습니다."
        case .notSupported:
            "지원하지 않는 로그인 방식입니다."
        case let .sdkError(error):
            "로그인 중 오류가 발생했습니다: \(error.localizedDescription)"
        case let .unknown(error):
            "알 수 없는 오류가 발생했습니다: \(error.localizedDescription)"
        }
    }
}
