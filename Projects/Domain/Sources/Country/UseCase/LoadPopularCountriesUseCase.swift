import Foundation

public protocol LoadPopularCountriesUseCase {
    func execute() throws -> [CountryDetail]
}

public final class DefaultLoadPopularCountriesUseCase: LoadPopularCountriesUseCase {
    private let countryRepo: CountryRepository

    public init(countryRepo: CountryRepository) {
        self.countryRepo = countryRepo
    }

    public func execute() throws -> [CountryDetail] {
        try countryRepo.loadPopularCountries()
    }
}
