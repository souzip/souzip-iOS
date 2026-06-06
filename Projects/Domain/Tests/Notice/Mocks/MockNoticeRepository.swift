import Foundation
@testable import Domain

final class MockNoticeRepository: NoticeRepository {
    var stubNotices: [Notice] = []
    var stubNoticeDetail = NoticeDetail(
        id: 1,
        title: "공지 제목",
        content: "공지 내용",
        createdAt: Date(timeIntervalSince1970: 1_700_000_000),
        imageURLs: []
    )

    var getNoticesError: Error?
    var getNoticeError: Error?

    private(set) var getNoticesCallCount = 0
    private(set) var getNoticeCallCount = 0
    private(set) var lastGetNoticeId: Int?

    func getNotices() async throws -> [Notice] {
        getNoticesCallCount += 1

        if let getNoticesError {
            throw getNoticesError
        }

        return stubNotices
    }

    func getNotice(id: Int) async throws -> NoticeDetail {
        getNoticeCallCount += 1
        lastGetNoticeId = id

        if let getNoticeError {
            throw getNoticeError
        }

        return stubNoticeDetail
    }
}

enum MockNoticeError: Error {
    case failed
}
