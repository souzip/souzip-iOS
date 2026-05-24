import XCTest
@testable import Domain

final class UploadPromptBubbleUseCaseTests: XCTestCase {
    func test_마이페이지미방문_버블표시() {
        let mock = MockUserRepository()
        mock.getHasVisitedMyPageResult = false
        let sut = DefaultUploadPromptBubbleUseCase(userRepository: mock)

        let shouldShow = sut.shouldShowBubble()

        XCTAssertTrue(shouldShow)
    }

    func test_마이페이지방문후_버블숨김() {
        let mock = MockUserRepository()
        mock.getHasVisitedMyPageResult = true
        let sut = DefaultUploadPromptBubbleUseCase(userRepository: mock)

        let shouldShow = sut.shouldShowBubble()

        XCTAssertFalse(shouldShow)
    }

    func test_방문표시_리포지토리위임() {
        let mock = MockUserRepository()
        let sut = DefaultUploadPromptBubbleUseCase(userRepository: mock)

        sut.markViewed()

        XCTAssertEqual(mock.markMyPageVisitedCallCount, 1)
    }
}
