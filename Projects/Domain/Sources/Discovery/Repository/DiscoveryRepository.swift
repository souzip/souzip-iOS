public protocol DiscoveryRepository {
    func getCountrySouvenirs() async throws -> [CountryTopSouvenir]
    func getTop10SouvenirsByCategory(category: SouvenirCategory) async throws -> [CatalogSouvenir]
    func getAIRecommendationByPreferenceCategory() async throws -> [CatalogSouvenir]
    func getAIRecommendationByPreferenceUpload() async throws -> [CatalogSouvenir]
}
