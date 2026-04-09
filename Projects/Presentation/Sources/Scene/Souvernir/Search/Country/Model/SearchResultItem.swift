import CoreLocation

enum SearchResultDetail {
    case city(subName: String)
    case place(category: String, region: String)
}

struct SearchResultItem: Hashable {
    let id: String
    let name: String
    let detail: SearchResultDetail
    let coordinate: CLLocationCoordinate2D

    static func == (lhs: SearchResultItem, rhs: SearchResultItem) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
