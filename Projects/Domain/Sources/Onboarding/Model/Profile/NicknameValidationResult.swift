public enum NicknameValidationResult {
    case valid(nickname: String)
    case invalid(nickname: String, error: NicknameValidationError)

    public var nickname: String {
        switch self {
        case let .valid(nickname),
             let .invalid(nickname, _):
            nickname
        }
    }

    public var nicknameErrorMessage: String? {
        switch self {
        case .valid:
            nil
        case let .invalid(_, error):
            error.errorDescription
        }
    }

    public var isValid: Bool {
        switch self {
        case .valid: true
        default: false
        }
    }
}
