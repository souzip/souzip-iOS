import Domain

enum CategoryPickerAction {
    case back
    case select(item: CategoryItem)
    case complete
}

struct CategoryPickerState {
    var items: [CategoryItem] = CategoryItem.defaultItems
    var selected: SouvenirCategory?
    var indexByCategory: [SouvenirCategory: Int] = Dictionary(
        uniqueKeysWithValues: CategoryItem.defaultItems.enumerated().map { ($0.element.category, $0.offset) }
    )

    var canComplete: Bool { selected != nil }
}

enum CategoryPickerEvent {
    case showToast(message: String)
    case showAlert(message: String)
}
