import Foundation

public protocol LoadCountryDetailUseCase {
    func execute(countryCode: String) throws -> CountryDetail
}

public final class DefaultLoadCountryDetailUseCase: LoadCountryDetailUseCase {
    private let countryRepo: CountryRepository

    public init(countryRepo: CountryRepository) {
        self.countryRepo = countryRepo
    }

    public func execute(countryCode: String) throws -> CountryDetail {
        try countryRepo.loadCountry(countryCode: countryCode)
    }
}
