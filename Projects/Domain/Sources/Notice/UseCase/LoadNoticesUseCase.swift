import Foundation

public protocol LoadNoticesUseCase {
    func execute() async throws -> [Notice]
}

public final class DefaultLoadNoticesUseCase: LoadNoticesUseCase {
    private let noticeRepo: NoticeRepository

    public init(noticeRepo: NoticeRepository) {
        self.noticeRepo = noticeRepo
    }

    public func execute() async throws -> [Notice] {
        try await noticeRepo.getNotices()
    }
}
