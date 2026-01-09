import CoreLocation

enum SearchResultType {
    case country
    case city
}

struct SearchResultItem: Hashable {
    let id: String
    let name: String
    let subName: String
    let type: SearchResultType
    let coordinate: CLLocationCoordinate2D

    public static func == (lhs: SearchResultItem, rhs: SearchResultItem) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
