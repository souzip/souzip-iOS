public protocol DomainNoticeFactory: AnyObject {
    func makeNoticeRepository() -> NoticeRepository
    func makeLoadNoticesUseCase() -> LoadNoticesUseCase
    func makeLoadNoticeDetailUseCase() -> LoadNoticeDetailUseCase
}

public extension DefaultDomainFactory {
    func makeNoticeRepository() -> NoticeRepository {
        factory.makeNoticeRepository()
    }

    func makeLoadNoticesUseCase() -> LoadNoticesUseCase {
        DefaultLoadNoticesUseCase(noticeRepo: makeNoticeRepository())
    }

    func makeLoadNoticeDetailUseCase() -> LoadNoticeDetailUseCase {
        DefaultLoadNoticeDetailUseCase(noticeRepo: makeNoticeRepository())
    }
}
