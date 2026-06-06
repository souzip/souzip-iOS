import XCTest
@testable import Domain

final class LoadNoticeDetailUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockNoticeRepository, DefaultLoadNoticeDetailUseCase) {
        let mockRepository = MockNoticeRepository()
        let sut = DefaultLoadNoticeDetailUseCase(noticeRepo: mockRepository)
        return (mockRepository, sut)
    }

    func test_공지상세조회성공_상세반환() async throws {
        let (mockRepository, sut) = makeSUT()
        let expectedDetail = NoticeDetail(
            id: 7,
            title: "업데이트 안내",
            content: "새 기능이 추가되었습니다.",
            createdAt: Date(timeIntervalSince1970: 1_700_200_000),
            imageURLs: ["https://example.com/notice.png"]
        )
        mockRepository.stubNoticeDetail = expectedDetail

        let result = try await sut.execute(id: 7)

        XCTAssertEqual(result, expectedDetail)
        XCTAssertEqual(mockRepository.getNoticeCallCount, 1)
        XCTAssertEqual(mockRepository.lastGetNoticeId, 7)
    }

    func test_공지ID전달_리포지토리호출() async throws {
        let (mockRepository, sut) = makeSUT()

        _ = try await sut.execute(id: 99)

        XCTAssertEqual(mockRepository.lastGetNoticeId, 99)
        XCTAssertEqual(mockRepository.getNoticeCallCount, 1)
    }

    func test_공지상세조회실패_에러전파() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.getNoticeError = MockNoticeError.failed

        do {
            _ = try await sut.execute(id: 1)
            XCTFail("에러가 발생해야 합니다")
        } catch {
            XCTAssertEqual(error as? MockNoticeError, .failed)
        }

        XCTAssertEqual(mockRepository.getNoticeCallCount, 1)
        XCTAssertEqual(mockRepository.lastGetNoticeId, 1)
    }
}
