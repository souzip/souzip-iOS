public struct TermsItem: Hashable {
    public let type: TermsType
    public var isAgreed: Bool

    public init(
        type: TermsType,
        isAgreed: Bool = false
    ) {
        self.type = type
        self.isAgreed = isAgreed
    }
}

public extension [TermsItem] {
    var isRequiredAllAgreed: Bool {
        filter(\.type.isRequired)
            .allSatisfy(\.isAgreed)
    }

    var isAllAgreed: Bool {
        allSatisfy(\.isAgreed)
    }
}
