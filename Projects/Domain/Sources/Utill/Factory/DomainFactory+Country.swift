public protocol DomainCountryFactory: AnyObject {
    func makeCountryRepository() -> CountryRepository
}

public extension DefaultDomainFactory {
    func makeCountryRepository() -> CountryRepository {
        factory.makeCountryRepository()
    }
}
