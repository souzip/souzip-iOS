import Foundation

/// 키워드 위치 검색 결과 리스트에서 한 건을 식별하기 위한 id (서버 숫자 id 없음 → Data에서 합성).
public struct LocationSearchHitID: Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

/// 키워드 검색 결과 1건. 서버 `type`은 `city` | `place`만 온다고 가정한다.
public enum LocationSearchHit: Hashable, Sendable {
    case city(CitySearchHit)
    case place(PlaceSearchHit)
}

public struct CitySearchHit: Hashable, Sendable {
    public let id: LocationSearchHitID
    public let title: String
    public let countryLine: String?
    public let coordinate: Coordinate

    public init(
        id: LocationSearchHitID,
        title: String,
        countryLine: String?,
        coordinate: Coordinate
    ) {
        self.id = id
        self.title = title
        self.countryLine = countryLine
        self.coordinate = coordinate
    }
}

public struct PlaceSearchHit: Hashable, Sendable {
    public let id: LocationSearchHitID
    public let title: String
    /// 장소 유형 표시 문구. Table A `category`만 한글 대분류로 채우고, Table B·미등록은 비운다(`nil`).
    public let placeKind: String?
    public let areaDescription: String?
    public let coordinate: Coordinate

    public init(
        id: LocationSearchHitID,
        title: String,
        placeKind: String?,
        areaDescription: String?,
        coordinate: Coordinate
    ) {
        self.id = id
        self.title = title
        self.placeKind = placeKind
        self.areaDescription = areaDescription
        self.coordinate = coordinate
    }
}
