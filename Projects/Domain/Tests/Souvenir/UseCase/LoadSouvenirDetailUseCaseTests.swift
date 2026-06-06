import XCTest
@testable import Domain

final class LoadSouvenirDetailUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockSouvenirRepository, DefaultLoadSouvenirDetailUseCase) {
        let mockRepository = MockSouvenirRepository()
        let sut = DefaultLoadSouvenirDetailUseCase(souvenirRepo: mockRepository)
        return (mockRepository, sut)
    }

    func test_정상호출_상세반환() async throws {
        let (mockRepository, sut) = makeSUT()
        mockRepository.stubSouvenirDetail = MockSouvenirRepository.makeStubDetail(
            id: 99,
            name: "상세 기념품"
        )

        let result = try await sut.execute(id: 99)

        XCTAssertEqual(result.id, 99)
        XCTAssertEqual(result.name, "상세 기념품")
        XCTAssertEqual(mockRepository.loadSouvenirCallCount, 1)
        XCTAssertEqual(mockRepository.lastLoadSouvenirId, 99)
    }

    func test_조회실패_에러전파() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.loadSouvenirError = MockSouvenirError.failed

        do {
            _ = try await sut.execute(id: 99)
            XCTFail("에러가 발생해야 합니다")
        } catch {
            XCTAssertEqual(error as? MockSouvenirError, .failed)
        }

        XCTAssertEqual(mockRepository.loadSouvenirCallCount, 1)
        XCTAssertEqual(mockRepository.lastLoadSouvenirId, 99)
    }
}
