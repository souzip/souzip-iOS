import Foundation

public protocol LoadAIRecommendationsForUploadUseCase {
    func execute() async throws -> [CatalogSouvenir]
}

public final class DefaultLoadAIRecommendationsForUploadUseCase: LoadAIRecommendationsForUploadUseCase {
    private let discoveryRepo: DiscoveryRepository

    public init(discoveryRepo: DiscoveryRepository) {
        self.discoveryRepo = discoveryRepo
    }

    public func execute() async throws -> [CatalogSouvenir] {
        try await discoveryRepo.loadAIRecommendationsForUpload()
    }
}
