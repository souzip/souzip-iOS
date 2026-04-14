public protocol DomainCountryFactory: AnyObject {
    func makeCountryRepository() -> CountryRepository

    func makeLoadPopularCountriesUseCase() -> LoadPopularCountriesUseCase
    func makeLoadCountryDetailUseCase() -> LoadCountryDetailUseCase
    func makeLoadLocationAddressUseCase() -> LoadLocationAddressUseCase
    func makeSearchLocationsUseCase() -> SearchLocationsUseCase
}

public extension DefaultDomainFactory {
    func makeCountryRepository() -> CountryRepository {
        factory.makeCountryRepository()
    }

    func makeLoadPopularCountriesUseCase() -> LoadPopularCountriesUseCase {
        DefaultLoadPopularCountriesUseCase(countryRepo: makeCountryRepository())
    }

    func makeLoadCountryDetailUseCase() -> LoadCountryDetailUseCase {
        DefaultLoadCountryDetailUseCase(countryRepo: makeCountryRepository())
    }

    func makeLoadLocationAddressUseCase() -> LoadLocationAddressUseCase {
        DefaultLoadLocationAddressUseCase(countryRepo: makeCountryRepository())
    }

    func makeSearchLocationsUseCase() -> SearchLocationsUseCase {
        DefaultSearchLocationsUseCase(countryRepo: makeCountryRepository())
    }
}
