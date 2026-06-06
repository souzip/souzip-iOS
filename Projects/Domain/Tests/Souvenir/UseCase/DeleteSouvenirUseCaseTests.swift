import XCTest
@testable import Domain

final class DeleteSouvenirUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockSouvenirRepository, DefaultDeleteSouvenirUseCase) {
        let mockRepository = MockSouvenirRepository()
        let sut = DefaultDeleteSouvenirUseCase(souvenirRepo: mockRepository)
        return (mockRepository, sut)
    }

    func test_정상호출_삭제실행() async throws {
        let (mockRepository, sut) = makeSUT()

        try await sut.execute(id: 7)

        XCTAssertEqual(mockRepository.deleteSouvenirCallCount, 1)
        XCTAssertEqual(mockRepository.lastDeleteId, 7)
    }

    func test_삭제실패_에러전파() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.deleteSouvenirError = MockSouvenirError.failed

        do {
            try await sut.execute(id: 7)
            XCTFail("에러가 발생해야 합니다")
        } catch {
            XCTAssertEqual(error as? MockSouvenirError, .failed)
        }

        XCTAssertEqual(mockRepository.deleteSouvenirCallCount, 1)
        XCTAssertEqual(mockRepository.lastDeleteId, 7)
    }
}
