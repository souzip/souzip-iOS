import XCTest
@testable import Domain

final class LoadNoticesUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockNoticeRepository, DefaultLoadNoticesUseCase) {
        let mockRepository = MockNoticeRepository()
        let sut = DefaultLoadNoticesUseCase(noticeRepo: mockRepository)
        return (mockRepository, sut)
    }

    func test_공지목록조회성공_목록반환() async throws {
        let (mockRepository, sut) = makeSUT()
        let expectedNotices = [
            Notice(id: 1, title: "첫 번째 공지", createdAt: Date(timeIntervalSince1970: 1_700_000_000)),
            Notice(id: 2, title: "두 번째 공지", createdAt: Date(timeIntervalSince1970: 1_700_100_000)),
        ]
        mockRepository.stubNotices = expectedNotices

        let result = try await sut.execute()

        XCTAssertEqual(result, expectedNotices)
        XCTAssertEqual(mockRepository.getNoticesCallCount, 1)
    }

    func test_공지목록조회실패_에러전파() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.getNoticesError = MockNoticeError.failed

        do {
            _ = try await sut.execute()
            XCTFail("에러가 발생해야 합니다")
        } catch {
            XCTAssertEqual(error as? MockNoticeError, .failed)
        }

        XCTAssertEqual(mockRepository.getNoticesCallCount, 1)
    }
}
