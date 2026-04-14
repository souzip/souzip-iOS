/// 기념품이 놓인 위치(주소·상세 줄·좌표). 수집 컨텍스트에서 주소 표시·지도의 단일 단위.
public struct SouvenirLocation: Equatable {
    public let address: String
    public let locationDetail: String?
    public let coordinate: Coordinate

    public init(
        address: String,
        locationDetail: String?,
        coordinate: Coordinate
    ) {
        self.address = address
        self.locationDetail = locationDetail
        self.coordinate = coordinate
    }
}
