import Domain

extension SouvenirPurpose {
    var title: String {
        switch self {
        case .gift: "선물용"
        case .personal: "개인용"
        }
    }
}
