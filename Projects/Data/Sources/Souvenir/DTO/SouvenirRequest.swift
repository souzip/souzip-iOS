import Foundation

// MARK: - Create/Update Souvenir

public struct SouvenirRequest: Encodable {
    public let name: String
    public let price: Int?
    public let currency: String?
    public let description: String
    public let address: String
    public let locationDetail: String?
    public let latitude: Double
    public let longitude: Double
    public let category: String
    public let purpose: String
    public let countryCode: String
    public let files: [String] // Empty array for JSON structure

    public init(
        name: String,
        price: Int? = nil,
        currency: String? = nil,
        description: String,
        address: String,
        locationDetail: String? = nil,
        latitude: Double,
        longitude: Double,
        category: String,
        purpose: String,
        countryCode: String
    ) {
        self.name = name
        self.price = price
        self.currency = currency
        self.description = description
        self.address = address
        self.locationDetail = locationDetail
        self.latitude = latitude
        self.longitude = longitude
        self.category = category
        self.purpose = purpose
        self.countryCode = countryCode
        files = []
    }
}

// MARK: - Multipart Data

public struct MultipartSouvenirData {
    public let souvenirRequest: SouvenirRequest
    public let imageFiles: [Data]

    public init(
        souvenirRequest: SouvenirRequest,
        imageFiles: [Data] = []
    ) {
        self.souvenirRequest = souvenirRequest
        self.imageFiles = imageFiles
    }
}
