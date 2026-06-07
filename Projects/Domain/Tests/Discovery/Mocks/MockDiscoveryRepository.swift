import Foundation
@testable import Domain

final class MockDiscoveryRepository: DiscoveryRepository {
    var stubCountrySouvenirs: [CountryTopSouvenir] = []
    var stubTopSouvenirsByCategory: [CatalogSouvenir] = []
    var stubAIRecommendationsForCategory: [CatalogSouvenir] = []
    var stubAIRecommendationsForUpload: [CatalogSouvenir] = []

    var loadCountrySouvenirsError: Error?
    var loadTopSouvenirsByCategoryError: Error?
    var loadAIRecommendationsForCategoryError: Error?
    var loadAIRecommendationsForUploadError: Error?

    private(set) var loadCountrySouvenirsCallCount = 0
    private(set) var loadTopSouvenirsByCategoryCallCount = 0
    private(set) var lastCategory: SouvenirCategory?
    private(set) var aiRecCategoryCallCount = 0
    private(set) var aiRecUploadCallCount = 0

    func loadCountrySouvenirs() async throws -> [CountryTopSouvenir] {
        loadCountrySouvenirsCallCount += 1

        if let loadCountrySouvenirsError {
            throw loadCountrySouvenirsError
        }

        return stubCountrySouvenirs
    }

    func loadTopSouvenirsByCategory(category: SouvenirCategory) async throws -> [CatalogSouvenir] {
        loadTopSouvenirsByCategoryCallCount += 1
        lastCategory = category

        if let loadTopSouvenirsByCategoryError {
            throw loadTopSouvenirsByCategoryError
        }

        return stubTopSouvenirsByCategory
    }

    func loadAIRecommendationsForCategory() async throws -> [CatalogSouvenir] {
        aiRecCategoryCallCount += 1

        if let loadAIRecommendationsForCategoryError {
            throw loadAIRecommendationsForCategoryError
        }

        return stubAIRecommendationsForCategory
    }

    func loadAIRecommendationsForUpload() async throws -> [CatalogSouvenir] {
        aiRecUploadCallCount += 1

        if let loadAIRecommendationsForUploadError {
            throw loadAIRecommendationsForUploadError
        }

        return stubAIRecommendationsForUpload
    }
}

enum MockDiscoveryError: Error {
    case failed
}
