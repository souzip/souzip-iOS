enum CollectionTab: Equatable, Hashable {
    case collection // 컬렉션
    case liked // 찜

    var title: String {
        switch self {
        case .collection: "컬렉션"
        case .liked: "찜"
        }
    }

    /// Parchment 페이지 인덱스 (0: 컬렉션, 1: 찜)
    var pageIndex: Int {
        switch self {
        case .collection: 0
        case .liked: 1
        }
    }

    init?(pageIndex: Int) {
        switch pageIndex {
        case 0: self = .collection
        case 1: self = .liked
        default: return nil
        }
    }
}
