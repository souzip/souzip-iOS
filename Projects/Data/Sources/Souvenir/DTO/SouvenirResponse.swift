import Foundation

// MARK: - Souvenir Detail

public struct SouvenirDetailResponse: Decodable {
    public let id: Int
    public let name: String
    public let price: SouvenirPriceResponse?
    public let description: String
    public let address: String
    public let locationDetail: String?
    public let latitude: Double
    public let longitude: Double
    public let category: String
    public let purpose: String
    public let countryCode: String
    public let userNickname: String
    public let userProfileImageUrl: String
    public let isOwned: Bool
    public let files: [SouvenirFileResponse]
}

public struct SouvenirPriceResponse: Decodable {
    public let original: SouvenirPriceUnitResponse
    public let converted: SouvenirPriceUnitResponse
}

public struct SouvenirPriceUnitResponse: Decodable {
    public let amount: Int
    public let symbol: String
}

public struct SouvenirFileResponse: Decodable {
    public let id: Int
    public let url: String
    public let originalName: String
    public let displayOrder: Int
}

// MARK: - Nearby Souvenirs

public struct NearbySouvenirsResponse: Decodable {
    public let souvenirs: [NearbySouvenirResponse]
}

public struct NearbySouvenirResponse: Decodable {
    public let id: Int
    public let name: String
    public let category: String
    public let purpose: String
    public let localPrice: Int?
    public let krwPrice: Int?
    public let currencySymbol: String?
    public let thumbnail: String
    public let latitude: Double
    public let longitude: Double
    public let address: String
}
