import Foundation

public protocol LoadAIRecommendationsForCategoryUseCase {
    func execute() async throws -> [CatalogSouvenir]
}

public final class DefaultLoadAIRecommendationsForCategoryUseCase: LoadAIRecommendationsForCategoryUseCase {
    private let discoveryRepo: DiscoveryRepository

    public init(discoveryRepo: DiscoveryRepository) {
        self.discoveryRepo = discoveryRepo
    }

    public func execute() async throws -> [CatalogSouvenir] {
        try await discoveryRepo.loadAIRecommendationsForCategory()
    }
}
