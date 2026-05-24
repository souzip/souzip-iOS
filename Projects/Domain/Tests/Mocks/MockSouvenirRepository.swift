import Foundation
import XCTest
@testable import Domain

final class MockSouvenirRepository: SouvenirRepository {
    var loadSouvenirResult: SouvenirDetail = DomainTestFixtures.souvenirDetail
    var createSouvenirResult: SouvenirDetail = DomainTestFixtures.souvenirDetail
    var updateSouvenirResult: SouvenirDetail = DomainTestFixtures.souvenirDetail
    var loadNearbySouvenirsResult: [SouvenirListItem] = [DomainTestFixtures.souvenirListItem]

    private(set) var loadSouvenirCallCount = 0
    private(set) var lastLoadSouvenirId: Int?
    private(set) var createSouvenirCallCount = 0
    private(set) var updateSouvenirCallCount = 0
    private(set) var deleteSouvenirCallCount = 0
    private(set) var lastDeleteSouvenirId: Int?
    private(set) var loadNearbySouvenirsCallCount = 0
    private(set) var lastNearbyLatitude: Double?
    private(set) var lastNearbyLongitude: Double?
    private(set) var lastNearbyRadiusMeter: Int?

    func loadSouvenir(id: Int) async throws -> SouvenirDetail {
        loadSouvenirCallCount += 1
        lastLoadSouvenirId = id
        return loadSouvenirResult
    }

    func createSouvenir(input: SouvenirInput, images: [Data]) async throws -> SouvenirDetail {
        createSouvenirCallCount += 1
        return createSouvenirResult
    }

    func updateSouvenir(id: Int, input: SouvenirInput) async throws -> SouvenirDetail {
        updateSouvenirCallCount += 1
        return updateSouvenirResult
    }

    func deleteSouvenir(id: Int) async throws {
        deleteSouvenirCallCount += 1
        lastDeleteSouvenirId = id
    }

    func loadNearbySouvenirs(
        latitude: Double,
        longitude: Double,
        radiusMeter: Int?
    ) async throws -> [SouvenirListItem] {
        loadNearbySouvenirsCallCount += 1
        lastNearbyLatitude = latitude
        lastNearbyLongitude = longitude
        lastNearbyRadiusMeter = radiusMeter
        return loadNearbySouvenirsResult
    }
}
