import Foundation

public protocol LoadNoticeDetailUseCase {
    func execute(id: Int) async throws -> NoticeDetail
}

public final class DefaultLoadNoticeDetailUseCase: LoadNoticeDetailUseCase {
    private let noticeRepo: NoticeRepository

    public init(noticeRepo: NoticeRepository) {
        self.noticeRepo = noticeRepo
    }

    public func execute(id: Int) async throws -> NoticeDetail {
        try await noticeRepo.getNotice(id: id)
    }
}
