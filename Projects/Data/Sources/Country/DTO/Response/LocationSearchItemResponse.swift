import Foundation

/// `GET /api/location/search` 응답의 `data` 배열 원소 1개.
public struct LocationSearchItemResponse: Decodable {
    public let type: String
    public let name: String
    public let country: String?
    public let address: String?
    public let region: String?
    public let category: String?
    public let coordinate: LocationCoordinateResponse
}

public struct LocationCoordinateResponse: Decodable {
    public let latitude: Double
    public let longitude: Double
}
