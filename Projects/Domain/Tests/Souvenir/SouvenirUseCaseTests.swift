import Foundation
import XCTest
@testable import Domain

final class SouvenirUseCaseTests: XCTestCase {
    func test_기념품상세_식별자전달() async throws {
        let mock = MockSouvenirRepository()
        let sut = DefaultLoadSouvenirDetailUseCase(souvenirRepo: mock)

        let result = try await sut.execute(id: 7)

        XCTAssertEqual(result.id, DomainTestFixtures.souvenirDetail.id)
        XCTAssertEqual(mock.loadSouvenirCallCount, 1)
        XCTAssertEqual(mock.lastLoadSouvenirId, 7)
    }

    func test_기념품생성_리포지토리위임() async throws {
        let mock = MockSouvenirRepository()
        let sut = DefaultCreateSouvenirUseCase(souvenirRepo: mock)

        let result = try await sut.execute(input: DomainTestFixtures.souvenirInput, images: [Data()])

        XCTAssertEqual(result.id, DomainTestFixtures.souvenirDetail.id)
        XCTAssertEqual(mock.createSouvenirCallCount, 1)
    }

    func test_기념품수정_리포지토리위임() async throws {
        let mock = MockSouvenirRepository()
        let sut = DefaultUpdateSouvenirUseCase(souvenirRepo: mock)

        let result = try await sut.execute(id: 3, input: DomainTestFixtures.souvenirInput)

        XCTAssertEqual(result.id, DomainTestFixtures.souvenirDetail.id)
        XCTAssertEqual(mock.updateSouvenirCallCount, 1)
    }

    func test_기념품삭제_식별자전달() async throws {
        let mock = MockSouvenirRepository()
        let sut = DefaultDeleteSouvenirUseCase(souvenirRepo: mock)

        try await sut.execute(id: 9)

        XCTAssertEqual(mock.deleteSouvenirCallCount, 1)
        XCTAssertEqual(mock.lastDeleteSouvenirId, 9)
    }

    func test_주변기념품_좌표전달() async throws {
        let mock = MockSouvenirRepository()
        let sut = DefaultLoadNearbySouvenirsUseCase(souvenirRepo: mock)

        let result = try await sut.execute(latitude: 37.0, longitude: 127.0, radiusMeter: 500)

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(mock.loadNearbySouvenirsCallCount, 1)
        XCTAssertEqual(mock.lastNearbyLatitude, 37.0)
        XCTAssertEqual(mock.lastNearbyLongitude, 127.0)
        XCTAssertEqual(mock.lastNearbyRadiusMeter, 500)
    }
}
