public protocol DiscoveryRepository {
    func loadCountrySouvenirs() async throws -> [CountryTopSouvenir]
    func loadTopSouvenirsByCategory(category: SouvenirCategory) async throws -> [CatalogSouvenir]
    func loadAIRecommendationsForCategory() async throws -> [CatalogSouvenir]
    func loadAIRecommendationsForUpload() async throws -> [CatalogSouvenir]
}
