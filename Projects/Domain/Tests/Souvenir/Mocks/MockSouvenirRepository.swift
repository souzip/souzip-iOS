import Foundation
@testable import Domain

final class MockSouvenirRepository: SouvenirRepository {
    var stubSouvenirDetail = MockSouvenirRepository.makeStubDetail()
    var stubNearbySouvenirs: [SouvenirListItem] = [MockSouvenirRepository.makeStubListItem()]

    var loadSouvenirError: Error?
    var createSouvenirError: Error?
    var updateSouvenirError: Error?
    var deleteSouvenirError: Error?
    var loadNearbySouvenirsError: Error?

    private(set) var loadSouvenirCallCount = 0
    private(set) var lastLoadSouvenirId: Int?

    private(set) var createSouvenirCallCount = 0
    private(set) var lastCreateInput: SouvenirInput?
    private(set) var lastCreateImages: [Data]?

    private(set) var updateSouvenirCallCount = 0
    private(set) var lastUpdateId: Int?
    private(set) var lastUpdateInput: SouvenirInput?

    private(set) var deleteSouvenirCallCount = 0
    private(set) var lastDeleteId: Int?

    private(set) var loadNearbySouvenirsCallCount = 0
    private(set) var lastLatitude: Double?
    private(set) var lastLongitude: Double?
    private(set) var lastRadiusMeter: Int?

    func loadSouvenir(id: Int) async throws -> SouvenirDetail {
        loadSouvenirCallCount += 1
        lastLoadSouvenirId = id

        if let loadSouvenirError {
            throw loadSouvenirError
        }

        return stubSouvenirDetail
    }

    func createSouvenir(input: SouvenirInput, images: [Data]) async throws -> SouvenirDetail {
        createSouvenirCallCount += 1
        lastCreateInput = input
        lastCreateImages = images

        if let createSouvenirError {
            throw createSouvenirError
        }

        return stubSouvenirDetail
    }

    func updateSouvenir(id: Int, input: SouvenirInput) async throws -> SouvenirDetail {
        updateSouvenirCallCount += 1
        lastUpdateId = id
        lastUpdateInput = input

        if let updateSouvenirError {
            throw updateSouvenirError
        }

        return stubSouvenirDetail
    }

    func deleteSouvenir(id: Int) async throws {
        deleteSouvenirCallCount += 1
        lastDeleteId = id

        if let deleteSouvenirError {
            throw deleteSouvenirError
        }
    }

    func loadNearbySouvenirs(
        latitude: Double,
        longitude: Double,
        radiusMeter: Int?
    ) async throws -> [SouvenirListItem] {
        loadNearbySouvenirsCallCount += 1
        lastLatitude = latitude
        lastLongitude = longitude
        lastRadiusMeter = radiusMeter

        if let loadNearbySouvenirsError {
            throw loadNearbySouvenirsError
        }

        return stubNearbySouvenirs
    }

    static func makeStubDetail(id: Int = 1, name: String = "테스트 기념품") -> SouvenirDetail {
        SouvenirDetail(
            id: id,
            name: name,
            price: SouvenirPrice(localAmount: 1000, localCurrencySymbol: "¥", krwAmount: 10000),
            description: "설명",
            location: SouvenirLocation(
                address: "도쿄",
                locationDetail: nil,
                coordinate: Coordinate(latitude: 35.6812, longitude: 139.7671)
            ),
            category: .snack,
            purpose: .personal,
            countryCode: "JP",
            isOwned: true,
            owner: SouvenirOwner(nickname: "tester", profileImageUrl: nil),
            files: [
                SouvenirFile(
                    id: 1,
                    url: "https://example.com/image.jpg",
                    originalName: "image.jpg",
                    displayOrder: 0
                ),
            ]
        )
    }

    static func makeStubInput(name: String = "새 기념품") -> SouvenirInput {
        SouvenirInput(
            name: name,
            price: 1000,
            currencyCode: "JPY",
            description: "설명",
            address: "도쿄",
            coordinate: Coordinate(latitude: 35.6812, longitude: 139.7671),
            category: .snack,
            purpose: .personal,
            countryCode: "JP"
        )
    }

    static func makeStubListItem(id: Int = 1, name: String = "테스트 기념품") -> SouvenirListItem {
        SouvenirListItem(
            id: id,
            name: name,
            category: .snack,
            purpose: .personal,
            localPrice: 1000,
            krwPrice: 10000,
            currencySymbol: "¥",
            thumbnail: "https://example.com/thumb.jpg",
            coordinate: Coordinate(latitude: 35.6812, longitude: 139.7671),
            address: "도쿄"
        )
    }
}

enum MockSouvenirError: Error {
    case failed
}
