import CoreLocation

enum SearchResultType {
    case city
    case place
}

struct SearchResultItem: Hashable {
    let id: String
    let name: String
    let subName: String
    let type: SearchResultType
    let placeCategory: String
    let placeRegion: String
    let coordinate: CLLocationCoordinate2D

    init(
        id: String,
        name: String,
        subName: String = "",
        type: SearchResultType,
        placeCategory: String = "",
        placeRegion: String = "",
        coordinate: CLLocationCoordinate2D
    ) {
        self.id = id
        self.name = name
        self.subName = subName
        self.type = type
        self.placeCategory = placeCategory
        self.placeRegion = placeRegion
        self.coordinate = coordinate
    }

    static func == (lhs: SearchResultItem, rhs: SearchResultItem) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
