import XCTest
@testable import Domain

final class MockNoticeRepository: NoticeRepository {
    var getNoticesResult: [Notice] = [DomainTestFixtures.notice]
    var getNoticeResult: NoticeDetail = DomainTestFixtures.noticeDetail

    private(set) var getNoticesCallCount = 0
    private(set) var getNoticeCallCount = 0
    private(set) var lastNoticeId: Int?

    func getNotices() async throws -> [Notice] {
        getNoticesCallCount += 1
        return getNoticesResult
    }

    func getNotice(id: Int) async throws -> NoticeDetail {
        getNoticeCallCount += 1
        lastNoticeId = id
        return getNoticeResult
    }
}
