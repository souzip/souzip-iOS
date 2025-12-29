import Domain

struct CountryResponseDTO: Decodable {
    let data: CountryDataDTO
}

struct CountryDataDTO: Decodable {
    let countries: [CountryDTO]
}

struct CountryDTO: Decodable {
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

struct RegionDTO: Decodable {
    let englishName: String
    let koreanName: String
}

struct CurrencyDTO: Decodable {
    let code: String
    let symbol: String
}

// MARK: - Mapping

extension CountryDTO {
    func toDomain() -> Country {
        Country(
            nameEnglish: nameEn,
            nameKorean: nameKr,
            code: code,
            region: region.toDomain(),
            capital: capital ?? "",
            flagImageURL: imageUrl,
            coordinate: Coordinate(latitude: latitude, longitude: longitude),
            currency: currency.toDomain()
        )
    }
}

extension RegionDTO {
    func toDomain() -> CountryRegion {
        CountryRegion(englishName: englishName, koreanName: koreanName)
    }
}

extension CurrencyDTO {
    func toDomain() -> CurrencyInfo {
        CurrencyInfo(code: code, symbol: symbol)
    }
}
