import XCTest
@testable import Domain

final class NoticeUseCaseTests: XCTestCase {
    func test_공지목록_리포지토리위임() async throws {
        let mock = MockNoticeRepository()
        let sut = DefaultLoadNoticesUseCase(noticeRepo: mock)

        let result = try await sut.execute()

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(mock.getNoticesCallCount, 1)
    }

    func test_공지상세_식별자전달() async throws {
        let mock = MockNoticeRepository()
        let sut = DefaultLoadNoticeDetailUseCase(noticeRepo: mock)

        let result = try await sut.execute(id: 42)

        XCTAssertEqual(result.id, DomainTestFixtures.noticeDetail.id)
        XCTAssertEqual(mock.getNoticeCallCount, 1)
        XCTAssertEqual(mock.lastNoticeId, 42)
    }
}
