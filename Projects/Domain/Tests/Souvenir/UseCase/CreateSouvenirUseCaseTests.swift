import XCTest
@testable import Domain

final class CreateSouvenirUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockSouvenirRepository, DefaultCreateSouvenirUseCase) {
        let mockRepository = MockSouvenirRepository()
        let sut = DefaultCreateSouvenirUseCase(souvenirRepo: mockRepository)
        return (mockRepository, sut)
    }

    func test_정상호출_기념품생성반환() async throws {
        let (mockRepository, sut) = makeSUT()
        let input = MockSouvenirRepository.makeStubInput(name: "말차 과자")
        let images = [Data([0x01, 0x02])]
        mockRepository.stubSouvenirDetail = MockSouvenirRepository.makeStubDetail(
            id: 42,
            name: "말차 과자"
        )

        let result = try await sut.execute(input: input, images: images)

        XCTAssertEqual(result.id, 42)
        XCTAssertEqual(result.name, "말차 과자")
        XCTAssertEqual(mockRepository.createSouvenirCallCount, 1)
        XCTAssertEqual(mockRepository.lastCreateInput?.name, "말차 과자")
        XCTAssertEqual(mockRepository.lastCreateImages, images)
    }

    func test_생성실패_에러전파() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.createSouvenirError = MockSouvenirError.failed
        let input = MockSouvenirRepository.makeStubInput()

        do {
            _ = try await sut.execute(input: input, images: [])
            XCTFail("에러가 발생해야 합니다")
        } catch {
            XCTAssertEqual(error as? MockSouvenirError, .failed)
        }

        XCTAssertEqual(mockRepository.createSouvenirCallCount, 1)
        XCTAssertEqual(mockRepository.lastCreateInput?.name, input.name)
    }
}
