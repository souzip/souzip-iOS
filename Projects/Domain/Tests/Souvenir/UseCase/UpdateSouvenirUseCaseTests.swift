import XCTest
@testable import Domain

final class UpdateSouvenirUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockSouvenirRepository, DefaultUpdateSouvenirUseCase) {
        let mockRepository = MockSouvenirRepository()
        let sut = DefaultUpdateSouvenirUseCase(souvenirRepo: mockRepository)
        return (mockRepository, sut)
    }

    func test_정상호출_기념품갱신반환() async throws {
        let (mockRepository, sut) = makeSUT()
        let input = MockSouvenirRepository.makeStubInput(name: "갱신 기념품")
        mockRepository.stubSouvenirDetail = MockSouvenirRepository.makeStubDetail(
            id: 15,
            name: "갱신 기념품"
        )

        let result = try await sut.execute(id: 15, input: input)

        XCTAssertEqual(result.id, 15)
        XCTAssertEqual(result.name, "갱신 기념품")
        XCTAssertEqual(mockRepository.updateSouvenirCallCount, 1)
        XCTAssertEqual(mockRepository.lastUpdateId, 15)
        XCTAssertEqual(mockRepository.lastUpdateInput?.name, "갱신 기념품")
    }

    func test_갱신실패_에러전파() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.updateSouvenirError = MockSouvenirError.failed
        let input = MockSouvenirRepository.makeStubInput()

        do {
            _ = try await sut.execute(id: 15, input: input)
            XCTFail("에러가 발생해야 합니다")
        } catch {
            XCTAssertEqual(error as? MockSouvenirError, .failed)
        }

        XCTAssertEqual(mockRepository.updateSouvenirCallCount, 1)
        XCTAssertEqual(mockRepository.lastUpdateId, 15)
        XCTAssertEqual(mockRepository.lastUpdateInput?.name, input.name)
    }
}
