import Foundation

public protocol LoadCountryTopSouvenirsUseCase {
    func execute() async throws -> [CountryTopSouvenir]
}

public final class DefaultLoadCountryTopSouvenirsUseCase: LoadCountryTopSouvenirsUseCase {
    private let discoveryRepo: DiscoveryRepository

    public init(discoveryRepo: DiscoveryRepository) {
        self.discoveryRepo = discoveryRepo
    }

    public func execute() async throws -> [CountryTopSouvenir] {
        try await discoveryRepo.loadCountrySouvenirs()
    }
}
