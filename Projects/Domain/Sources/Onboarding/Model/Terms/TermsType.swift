public enum TermsType: Equatable {
    case age14
    case service
    case privacy
    case location
    case marketing
}

public extension TermsType {
    var isRequired: Bool {
        switch self {
        case .marketing: false
        default: true
        }
    }
}
