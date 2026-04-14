public protocol DomainDiscoveryFactory: AnyObject {
    func makeDiscoveryRepository() -> DiscoveryRepository

    func makeLoadCountryTopSouvenirsUseCase() -> LoadCountryTopSouvenirsUseCase
    func makeLoadTopSouvenirsByCategoryUseCase() -> LoadTopSouvenirsByCategoryUseCase
    func makeLoadAIRecommendationsForCategoryUseCase() -> LoadAIRecommendationsForCategoryUseCase
    func makeLoadAIRecommendationsForUploadUseCase() -> LoadAIRecommendationsForUploadUseCase
}

public extension DefaultDomainFactory {
    func makeDiscoveryRepository() -> DiscoveryRepository {
        factory.makeDiscoveryRepository()
    }

    func makeLoadCountryTopSouvenirsUseCase() -> LoadCountryTopSouvenirsUseCase {
        DefaultLoadCountryTopSouvenirsUseCase(discoveryRepo: makeDiscoveryRepository())
    }

    func makeLoadTopSouvenirsByCategoryUseCase() -> LoadTopSouvenirsByCategoryUseCase {
        DefaultLoadTopSouvenirsByCategoryUseCase(discoveryRepo: makeDiscoveryRepository())
    }

    func makeLoadAIRecommendationsForCategoryUseCase() -> LoadAIRecommendationsForCategoryUseCase {
        DefaultLoadAIRecommendationsForCategoryUseCase(discoveryRepo: makeDiscoveryRepository())
    }

    func makeLoadAIRecommendationsForUploadUseCase() -> LoadAIRecommendationsForUploadUseCase {
        DefaultLoadAIRecommendationsForUploadUseCase(discoveryRepo: makeDiscoveryRepository())
    }
}
