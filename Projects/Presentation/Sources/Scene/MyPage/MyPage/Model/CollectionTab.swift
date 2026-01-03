enum CollectionTab {
    case collection // 컬렉션
    case liked // 찜

    var title: String {
        switch self {
        case .collection: "컬렉션"
        case .liked: "찜"
        }
    }
}
