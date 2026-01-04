public protocol DiscoveryRepository {
    func getTop10SouvenirsByCountry(countryCode: String) async throws -> [DiscoverySouvenir]
    func getTop10SouvenirsByCategory(category: SouvenirCategory) async throws -> [DiscoverySouvenir]
    func getTop3CountryStats() async throws -> [DiscoveryCountryStat]
    func getAIRecommendationByPreferenceCategory() async throws -> [DiscoverySouvenir]
    func getAIRecommendationByPreferenceUpload() async throws -> [DiscoverySouvenir]
}
