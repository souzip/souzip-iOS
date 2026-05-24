import XCTest
@testable import Domain

final class MockDiscoveryRepository: DiscoveryRepository {
    var loadCountrySouvenirsResult: [CountryTopSouvenir] = [DomainTestFixtures.countryTopSouvenir]
    var loadTopSouvenirsByCategoryResult: [CatalogSouvenir] = [DomainTestFixtures.catalogSouvenir]
    var loadAIRecommendationsForCategoryResult: [CatalogSouvenir] = [DomainTestFixtures.catalogSouvenir]
    var loadAIRecommendationsForUploadResult: [CatalogSouvenir] = [DomainTestFixtures.catalogSouvenir]

    private(set) var loadCountrySouvenirsCallCount = 0
    private(set) var loadTopSouvenirsByCategoryCallCount = 0
    private(set) var lastCategory: SouvenirCategory?
    private(set) var loadAIRecommendationsForCategoryCallCount = 0
    private(set) var loadAIRecommendationsForUploadCallCount = 0

    func loadCountrySouvenirs() async throws -> [CountryTopSouvenir] {
        loadCountrySouvenirsCallCount += 1
        return loadCountrySouvenirsResult
    }

    func loadTopSouvenirsByCategory(category: SouvenirCategory) async throws -> [CatalogSouvenir] {
        loadTopSouvenirsByCategoryCallCount += 1
        lastCategory = category
        return loadTopSouvenirsByCategoryResult
    }

    func loadAIRecommendationsForCategory() async throws -> [CatalogSouvenir] {
        loadAIRecommendationsForCategoryCallCount += 1
        return loadAIRecommendationsForCategoryResult
    }

    func loadAIRecommendationsForUpload() async throws -> [CatalogSouvenir] {
        loadAIRecommendationsForUploadCallCount += 1
        return loadAIRecommendationsForUploadResult
    }
}
