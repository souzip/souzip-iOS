public protocol DomainNoticeFactory: AnyObject {
    func makeNoticeRepository() -> NoticeRepository
}

public extension DefaultDomainFactory {
    func makeNoticeRepository() -> NoticeRepository {
        factory.makeNoticeRepository()
    }
}
