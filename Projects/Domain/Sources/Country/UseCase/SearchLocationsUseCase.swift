import Foundation

public protocol SearchLocationsUseCase {
    func execute(keyword: String) async throws -> [LocationSearchHit]
}

public final class DefaultSearchLocationsUseCase: SearchLocationsUseCase {
    private let countryRepo: CountryRepository

    public init(countryRepo: CountryRepository) {
        self.countryRepo = countryRepo
    }

    public func execute(keyword: String) async throws -> [LocationSearchHit] {
        try await countryRepo.searchLocations(keyword: keyword)
    }
}
