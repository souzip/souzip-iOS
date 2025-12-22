public struct TermsItem: Hashable {
    public let type: TermsType
    public let isRequired: Bool
    public var isAgreed: Bool

    public init(
        type: TermsType,
        isRequired: Bool,
        isAgreed: Bool = false
    ) {
        self.type = type
        self.isRequired = isRequired
        self.isAgreed = isAgreed
    }
}

public extension [TermsItem] {
    var isRequiredAllAgreed: Bool {
        filter(\.isRequired)
            .allSatisfy(\.isAgreed)
    }

    var isAllAgreed: Bool {
        allSatisfy(\.isAgreed)
    }
}
