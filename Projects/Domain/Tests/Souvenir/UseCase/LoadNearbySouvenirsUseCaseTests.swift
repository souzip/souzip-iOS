import XCTest
@testable import Domain

final class LoadNearbySouvenirsUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockSouvenirRepository, DefaultLoadNearbySouvenirsUseCase) {
        let mockRepository = MockSouvenirRepository()
        let sut = DefaultLoadNearbySouvenirsUseCase(souvenirRepo: mockRepository)
        return (mockRepository, sut)
    }

    func test_정상호출_목록반환() async throws {
        let (mockRepository, sut) = makeSUT()
        mockRepository.stubNearbySouvenirs = [
            MockSouvenirRepository.makeStubListItem(id: 1, name: "기념품A"),
            MockSouvenirRepository.makeStubListItem(id: 2, name: "기념품B"),
        ]

        let result = try await sut.execute(
            latitude: 35.6812,
            longitude: 139.7671,
            radiusMeter: 500
        )

        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].id, 1)
        XCTAssertEqual(result[1].id, 2)
        XCTAssertEqual(mockRepository.loadNearbySouvenirsCallCount, 1)
        XCTAssertEqual(mockRepository.lastLatitude, 35.6812)
        XCTAssertEqual(mockRepository.lastLongitude, 139.7671)
        XCTAssertEqual(mockRepository.lastRadiusMeter, 500)
    }

    func test_조회실패_에러전파() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.loadNearbySouvenirsError = MockSouvenirError.failed

        do {
            _ = try await sut.execute(latitude: 35.6812, longitude: 139.7671, radiusMeter: nil)
            XCTFail("에러가 발생해야 합니다")
        } catch {
            XCTAssertEqual(error as? MockSouvenirError, .failed)
        }

        XCTAssertEqual(mockRepository.loadNearbySouvenirsCallCount, 1)
        XCTAssertNil(mockRepository.lastRadiusMeter)
    }
}
