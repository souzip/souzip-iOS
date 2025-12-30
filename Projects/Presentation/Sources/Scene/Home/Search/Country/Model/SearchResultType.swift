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

    // 목 데이터용
    static func mockData() -> [SearchResultItem] {
        [
            SearchResultItem(
                id: "1",
                name: "일본",
                subName: "일본",
                type: .country,
                coordinate: CLLocationCoordinate2D(latitude: 36.0, longitude: 138.0)
            ),
            SearchResultItem(
                id: "2",
                name: "오사카",
                subName: "일본",
                type: .city,
                coordinate: CLLocationCoordinate2D(latitude: 36.2048, longitude: 138.2529)
            ),
            SearchResultItem(
                id: "3",
                name: "도쿄",
                subName: "일본",
                type: .city,
                coordinate: CLLocationCoordinate2D(latitude: 36.2048, longitude: 138.2529)
            ),
            SearchResultItem(
                id: "4",
                name: "상포르",
                subName: "일본",
                type: .city,
                coordinate: CLLocationCoordinate2D(latitude: 36.2048, longitude: 138.2529)
            ),
            SearchResultItem(
                id: "5",
                name: "후쿠오카",
                subName: "일본",
                type: .city,
                coordinate: CLLocationCoordinate2D(latitude: 36.2048, longitude: 138.2529)
            ),
            SearchResultItem(
                id: "6",
                name: "오키나와",
                subName: "일본",
                type: .city,
                coordinate: CLLocationCoordinate2D(latitude: 36.2048, longitude: 138.2529)
            ),
            SearchResultItem(
                id: "7",
                name: "하코네",
                subName: "일본",
                type: .city,
                coordinate: CLLocationCoordinate2D(latitude: 36.2048, longitude: 138.2529)
            ),
        ]
    }

    public static func == (lhs: SearchResultItem, rhs: SearchResultItem) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
