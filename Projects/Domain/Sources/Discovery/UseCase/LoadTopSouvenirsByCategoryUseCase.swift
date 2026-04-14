import Foundation

public protocol LoadTopSouvenirsByCategoryUseCase {
    func execute(category: SouvenirCategory) async throws -> [CatalogSouvenir]
}

public final class DefaultLoadTopSouvenirsByCategoryUseCase: LoadTopSouvenirsByCategoryUseCase {
    private let discoveryRepo: DiscoveryRepository

    public init(discoveryRepo: DiscoveryRepository) {
        self.discoveryRepo = discoveryRepo
    }

    public func execute(category: SouvenirCategory) async throws -> [CatalogSouvenir] {
        try await discoveryRepo.loadTopSouvenirsByCategory(category: category)
    }
}
