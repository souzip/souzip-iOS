public protocol DiscoveryRepository {
    func getCountrySouvenirs() async throws -> [CountryTopSouvenir]
    func getTop10SouvenirsByCategory(category: SouvenirCategory) async throws -> [DiscoverySouvenir]
    func getAIRecommendationByPreferenceCategory() async throws -> [DiscoverySouvenir]
    func getAIRecommendationByPreferenceUpload() async throws -> [DiscoverySouvenir]
}
