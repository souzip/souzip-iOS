import Domain

struct CountryResponseDTO: Decodable {
    let data: CountryDataDTO
}

struct CountryDataDTO: Decodable {
    let countries: [CountryDTO]
}

public struct CountryDTO: Decodable {
    let nameEn: String
    let nameKr: String
    let code: String
    let region: RegionDTO
    let capital: String?
    let imageUrl: String
    let latitude: Double
    let longitude: Double
    let currency: CurrencyDTO
}

public struct RegionDTO: Decodable {
    let englishName: String
    let koreanName: String
}

public struct CurrencyDTO: Decodable {
    let code: String
    let symbol: String
}
