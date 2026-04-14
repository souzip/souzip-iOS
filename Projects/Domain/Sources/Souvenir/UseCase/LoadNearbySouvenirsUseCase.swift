import Foundation

public protocol LoadNearbySouvenirsUseCase {
    func execute(
        latitude: Double,
        longitude: Double,
        radiusMeter: Int?
    ) async throws -> [SouvenirListItem]
}

public final class DefaultLoadNearbySouvenirsUseCase: LoadNearbySouvenirsUseCase {
    private let souvenirRepo: SouvenirRepository

    public init(souvenirRepo: SouvenirRepository) {
        self.souvenirRepo = souvenirRepo
    }

    public func execute(
        latitude: Double,
        longitude: Double,
        radiusMeter: Int?
    ) async throws -> [SouvenirListItem] {
        try await souvenirRepo.loadNearbySouvenirs(
            latitude: latitude,
            longitude: longitude,
            radiusMeter: radiusMeter
        )
    }
}
