import XCTest
@testable import Domain

final class UploadPromptBubbleUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockUserRepository, DefaultUploadPromptBubbleUseCase) {
        let mockRepository = MockUserRepository()
        let sut = DefaultUploadPromptBubbleUseCase(userRepository: mockRepository)
        return (mockRepository, sut)
    }

    func test_마이페이지미방문_버블표시() {
        let (mockRepository, sut) = makeSUT()
        mockRepository.stubHasVisitedMyPage = false

        let result = sut.shouldShowBubble()

        XCTAssertTrue(result)
        XCTAssertEqual(mockRepository.getHasVisitedMyPageCallCount, 1)
    }

    func test_마이페이지방문완료_버블숨김() {
        let (mockRepository, sut) = makeSUT()
        mockRepository.stubHasVisitedMyPage = true

        let result = sut.shouldShowBubble()

        XCTAssertFalse(result)
        XCTAssertEqual(mockRepository.getHasVisitedMyPageCallCount, 1)
    }

    func test_조회완료처리_방문기록저장() {
        let (mockRepository, sut) = makeSUT()

        sut.markViewed()

        XCTAssertEqual(mockRepository.markMyPageVisitedCallCount, 1)
    }
}
