import Foundation

// MARK: - Create/Update Souvenir

public struct SouvenirRequest: Encodable {
    public let name: String
    public let localPrice: Int?
    public let currencySymbol: String?
    public let krwPrice: Int?
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
        localPrice: Int? = nil,
        currencySymbol: String? = nil,
        krwPrice: Int? = nil,
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
        self.localPrice = localPrice
        self.currencySymbol = currencySymbol
        self.krwPrice = krwPrice
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
