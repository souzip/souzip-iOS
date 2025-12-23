import Domain

struct CategoryItem: Hashable {
    let category: SouvenirCategory
    var isSelected: Bool
}

extension CategoryItem {
    static var defaultItems: [CategoryItem] {
        SouvenirCategory.allCases.map {
            .init(category: $0, isSelected: false)
        }
    }
}
