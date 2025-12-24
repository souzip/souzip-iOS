import Domain

enum CategoryAction {
    case back
    case toggle(item: CategoryItem)
    case complete
}

struct CategoryState {
    var items: [CategoryItem] = CategoryItem.defaultItems
    var selected: Set<SouvenirCategory> = []
    var indexByCategory: [SouvenirCategory: Int] = Dictionary(
        uniqueKeysWithValues: CategoryItem.defaultItems.enumerated().map { ($0.element.category, $0.offset) }
    )

    var canComplete: Bool { selected.count >= 1 }
}

enum CategoryEvent {
    case showToast(message: String)
}
