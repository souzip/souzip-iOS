import Foundation

public protocol LoadLocationAddressUseCase {
    func execute(latitude: Double, longitude: Double) async throws -> LocationAddress
}

public final class DefaultLoadLocationAddressUseCase: LoadLocationAddressUseCase {
    private let countryRepo: CountryRepository

    public init(countryRepo: CountryRepository) {
        self.countryRepo = countryRepo
    }

    public func execute(latitude: Double, longitude: Double) async throws -> LocationAddress {
        try await countryRepo.loadAddress(latitude: latitude, longitude: longitude)
    }
}
