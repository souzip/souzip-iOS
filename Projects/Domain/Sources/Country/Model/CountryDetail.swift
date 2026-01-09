public struct CountryDetail {
    public let nameEnglish: String
    public let nameKorean: String
    public let code: String
    public let region: CountryRegion
    public let capital: String
    public let flagImageURL: String
    public let coordinate: Coordinate
    public let currency: CurrencyInfo

    public init(
        nameEnglish: String,
        nameKorean: String,
        code: String,
        region: CountryRegion,
        capital: String,
        flagImageURL: String,
        coordinate: Coordinate,
        currency: CurrencyInfo
    ) {
        self.nameEnglish = nameEnglish
        self.nameKorean = nameKorean
        self.code = code
        self.region = region
        self.capital = capital
        self.flagImageURL = flagImageURL
        self.coordinate = coordinate
        self.currency = currency
    }
}
