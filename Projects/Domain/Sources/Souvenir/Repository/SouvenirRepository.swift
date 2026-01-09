import Foundation

public protocol SouvenirRepository {
    func getSouvenir(id: Int) async throws -> SouvenirDetail
    func createSouvenir(input: SouvenirInput, images: [Data]) async throws -> SouvenirDetail
    func updateSouvenir(id: Int, input: SouvenirInput) async throws -> SouvenirDetail
    func deleteSouvenir(id: Int) async throws
    func getNearbySouvenirs(
        latitude: Double,
        longitude: Double,
        radiusMeter: Int?
    ) async throws -> [SouvenirListItem]
    func consumeMyPageNeedsRefresh() async -> Bool
}
